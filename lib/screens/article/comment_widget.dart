import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/comment.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:poly_lingua_app/utils/format_time.dart';

class ArticleCommentSection extends StatefulWidget {
  final String articleTitle;
  const ArticleCommentSection({super.key, required this.articleTitle});

  @override
  State<ArticleCommentSection> createState() => _ArticleCommentSectionState();
}

class _ArticleCommentSectionState extends State<ArticleCommentSection> {
  final _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userController = Get.find<UserController>();
  final List<Comment> _comments = <Comment>[];
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    // query comments from Firestore
    _firestore
        .collection('comments')
        .where('articleTitle', isEqualTo: widget.articleTitle)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
          var data = document.data() ?? {};
          var comment = Comment.fromJson(data);
          setState(() {
            _comments.add(comment);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      // Create new document in collection 'comments'
      final docRef = _firestore.collection('comments').doc();
      final newComment = Comment(
        id: docRef.id,
        content: _commentController.text.trim(),
        articleTitle: widget.articleTitle,
        userId: userController.user!.id!,
        fullName: userController.user!.fullName!,
        imageUrl: userController.user!.image!,
        createdAt: Timestamp.now(),
      );

      docRef.set(newComment.toJson()).then((value) {
        Get.snackbar(
          'Success',
          'Comment added',
          titleText: const Text(
            'Success',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorText: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.5),
          borderRadius: 6.0,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 3),
            ),
          ],
        );
        setState(() {
          _comments.insert(0, newComment);
          _commentController.clear();
        });
      }).catchError((error) {
        print('Failed to add comment: $error');
      });
    }
  }

  void _deleteComment(String commentId) {
    _firestore.collection('comments').doc(commentId).delete().then((value) {
      setState(() {
        _comments.removeWhere((comment) => comment.id == commentId);
      });
      Get.snackbar(
        'Success',
        'Comment deleted',
        titleText: const Text(
          'Success',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorText: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.5),
        borderRadius: 6.0,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 3),
          ),
        ],
      );
    }).catchError((error) {
      print('Failed to delete comment: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: showMore
                ? _comments.length
                : (_comments.length > 5 ? 5 : _comments.length),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(_comments[index].imageUrl),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _comments[index].fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            getCommentTimeDifference(
                                _comments[index].createdAt.toDate()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(_comments[index].content),
                        ],
                      ),
                    ),
                    if (userController.user!.id == _comments[index].userId)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _deleteComment(_comments[index].id);
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_comments.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                showMore = !showMore;
              });
            },
            child: Center(
              child: Text(
                showMore ? 'Show Less' : 'Read More',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _commentController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Write a comment...',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.blueAccent,
              ),
              onPressed: _submitComment,
            ),
          ),
        ),
      ],
    );
  }
}
