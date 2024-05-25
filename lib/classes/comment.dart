import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final String articleTitle;
  final String userId;
  final String fullName;
  final String imageUrl;
  final Timestamp createdAt;

  const Comment({
    required this.id,
    required this.content,
    required this.articleTitle,
    required this.userId,
    required this.fullName,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'articleTitle': articleTitle,
      'userId': userId,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      articleTitle: json['articleTitle'],
      userId: json['userId'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }
}
