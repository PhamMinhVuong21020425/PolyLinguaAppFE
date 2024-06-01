import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_lingua_app/classes/word_data.dart';

class ArticleController extends GetxController {
  ArticleController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxString summaryObs = ''.obs;
  final RxList<WordData> wordDataObs = <WordData>[].obs;

  Future<String> summarizeContent(String content, String language) async {
    final snapshot = await _firestore.collection("servers").get();
    final docs = snapshot.docs;
    final server = docs[0].data() as Map;
    print(server['summarization_api']);

    final url = Uri.parse('${server['summarization_api']}/api/v1/summarize');
    final body = jsonEncode({"query": content, "language": language});

    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        final summary = data['result'] as String;

        return summary;
      } else {
        throw Exception('Failed to summarize content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to summarize content: $e');
    }
  }

  Future<void> fetchSummary(
    String content,
    String language,
    BuildContext context,
  ) async {
    try {
      wordDataObs.value = [];
      print('Fetching summary...');
      final summary = await summarizeContent(content, language);
      summaryObs.value = summary;
      print('Done fetching summary!');
    } catch (e) {
      if (!context.mounted) return;
      print('Failed to fetch summary: $e');
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Error'),
      //     content: Text('Failed to fetch summary: $e'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  Future<void> analyzeContent(String content, String language) async {
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

        wordDataObs.value = wordData;
      } else {
        throw Exception('Failed to analyze content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze content: $e');
    }
  }
}
