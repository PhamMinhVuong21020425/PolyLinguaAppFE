import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/screens/article/article_controller.dart';

class ClassifierButton extends StatefulWidget {
  final Article article;

  const ClassifierButton({super.key, required this.article});

  @override
  State<ClassifierButton> createState() => _ClassifierButtonState();
}

class _ClassifierButtonState extends State<ClassifierButton> {
  final articleController = Get.find<ArticleController>();
  String knn = '';
  String bayes = '';
  String tree = '';

  String? _loadingButton;

  Future<void> _classifyArticle(String method) async {
    setState(() {
      _loadingButton = method;
      // Reset result for the specific method
      switch (method) {
        case 'knn':
          knn = '';
          break;
        case 'bayes':
          bayes = '';
          break;
        case 'tree':
          tree = '';
          break;
      }
    });

    try {
      final value = await articleController.classifyArticle(
        widget.article.content,
        method,
        widget.article.language,
      );

      setState(() {
        switch (method) {
          case 'knn':
            knn = value;
            break;
          case 'bayes':
            bayes = value;
            break;
          case 'tree':
            tree = value;
            break;
        }
        _loadingButton = null;
      });
    } catch (e) {
      setState(() {
        _loadingButton = null;
      });
    }
  }

  Widget _buildClassificationButton(
      String method, String label, String result, Color color) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          onPressed:
              _loadingButton == null ? () => _classifyArticle(method) : null,
          child: Text(label),
        ),
        const SizedBox(height: 8),
        _loadingButton == method
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            : Text(
                result,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildClassificationButton('knn', 'KNN', knn, Colors.blue),
        _buildClassificationButton('bayes', 'Naive Bayes', bayes, Colors.red),
        _buildClassificationButton('tree', 'Decision Tree', tree, Colors.green),
      ],
    );
  }
}
