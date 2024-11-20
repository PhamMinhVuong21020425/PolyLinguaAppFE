import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:poly_lingua_app/classes/article.dart';

Future<List<Article>> fetchArticlesFromJson(bool isEnglish) async {
  String jsonString = isEnglish
      ? await rootBundle.loadString('assets/data/news-en.json')
      : await rootBundle.loadString('assets/data/news-ja.json');

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
      views: json['views'] ?? 0,
    );
  }).toList();

  return articles;
}

Future<List<dynamic>> readJsonFile(bool isEnglish) async {
  String jsonString = isEnglish
      ? await rootBundle.loadString('assets/data/news-en.json')
      : await rootBundle.loadString('assets/data/news-ja.json');

  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList;
}

Future<List<dynamic>> readLocalFile(bool isEnglish) async {
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  var file =
      isEnglish ? File('$path/news-en.json') : File('$path/news-ja.json');

  final exists = await file.exists();
  print('0. File exists? $exists');

  if (exists) {
    final jsonString = await file.readAsString();
    print('1. JSON string: $jsonString');

    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList;
  }

  return [];
}

Future<void> writeJsonFile(List<dynamic> data, bool isEnglish) async {
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  var file =
      isEnglish ? File('$path/news-en.json') : File('$path/news-ja.json');

  var sink = file.openWrite();
  final jsonData = jsonEncode(data);

  // file.writeAsStringSync(jsonData);
  sink.write(jsonData);
  await sink.flush();

  // Close the IOSink to free system resources.
  await sink.close();
  print('Data written to file.');
}
