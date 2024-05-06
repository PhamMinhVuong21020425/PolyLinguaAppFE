import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:poly_lingua_app/classes/article.dart';

Future<List<Article>> fetchArticlesFromJson(bool isEnglish) async {
  String jsonString = isEnglish
      ? await rootBundle.loadString('assets/data/newsweek-en.json')
      : await rootBundle.loadString('assets/data/asahi-news-ja.json');

  List<dynamic> jsonList = json.decode(jsonString);
  List<Article> articles = jsonList.map((json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      image: json['image'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      language: json['language'],
    );
  }).toList();

  return articles;
}
