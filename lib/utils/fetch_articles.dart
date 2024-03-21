import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:poly_lingua_app/models/article.dart';

Future<List<Article>> fetchArticlesFromJson() async {
  String jsonString = await rootBundle.loadString('assets/data/articles.json');

  List<dynamic> jsonList = json.decode(jsonString);
  List<Article> articles = jsonList.map((json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      image: json['image'],
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'],
    );
  }).toList();

  return articles;
}
