import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:poly_lingua_app/classes/word_data.dart';
import 'package:poly_lingua_app/utils/calculate_read_time.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';

class ArticleScreen extends StatelessWidget {
  // final Article article;

  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data from arguments of the route
    final article = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the home page
            Navigator.of(context).pop();
          },
        ),
        title: const Text('News Article'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Published: ${formatDate(article.publishedAt)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Read Time: ${calculateReadTime(article.content)} minutes',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<WordData>>(
                    future: analyzeContent(article.content, article.language),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SelectableText.rich(
                          TextSpan(
                            children: parseContent(snapshot.data!, context),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 3.0,
                          )),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  String formatDate(DateTime date) {
    // Implement date formatting logic
    return '${date.day}/${date.month}/${date.year}';
  }

  List<InlineSpan> parseContent(List<WordData> wordData, BuildContext context) {
    final List<InlineSpan> spans = [];

    for (final word in wordData) {
      spans.add(
        TextSpan(
          text: '${word.word} ',
          style: TextStyle(
            color: getColorForPart(word.pos),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showWordInfo(word, context);
            },
        ),
      );
    }

    return spans;
  }

  Color getColorForPart(String part) {
    switch (part) {
      case 'NOUN' || '名詞':
        return Colors.green;
      case 'VERB' || '動詞':
        return Colors.red;
      case 'ADJ' || '形容詞':
        return Colors.purple;
      // Add more cases for other parts of speech
      default:
        return Colors.black;
    }
  }

  void showWordInfo(WordData wordData, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(wordData.word),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Part of Speech: ${wordData.pos}'),
              const SizedBox(height: 8),
              Text('Definition: ${wordData.definition}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<WordData>> analyzeContent(String content, String language) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/v1/analyze');
    final body = jsonEncode({"text": content, "language": language});

    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final wordData = data
            .map((item) => WordData(
                  word: item['word'],
                  pos: item['pos'],
                  definition: item['definition'],
                ))
            .toList();

        return wordData;
      } else {
        throw Exception('Failed to analyze content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze content: $e');
    }
  }
}
