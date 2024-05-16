import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';

class UserClient {
  final String? id;
  final String? email;
  final String? password;
  final String? fullName;
  final String? image;
  final String? birthday;
  final String? numberPhone;
  final String? address;
  String? language;
  List<Article>? articles;
  List<Flashcard>? vocabularies;

  UserClient(
    this.id,
    this.email,
    this.password,
    this.fullName,
    this.image,
    this.birthday,
    this.numberPhone,
    this.address,
    this.language,
    this.articles,
    this.vocabularies,
  );

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson =
        articles!.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> vocabulariesJson =
        vocabularies!.map((flashcard) => flashcard.toJson()).toList();

    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'image': image,
      'birthday': birthday,
      'numberPhone': numberPhone,
      'address': address,
      'language': language,
      'articles': articlesJson,
      'vocabularies': vocabulariesJson,
    };
  }

  static UserClient fromJson(Map<String, dynamic> json) {
    List<Article> articlesObject = (json['articles'] as List)
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();
    List<Flashcard> vocabulariesObject = (json['vocabularies'] as List)
        .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
        .toList();

    return UserClient(
      json['id'],
      json['email'],
      json['password'],
      json['fullName'],
      json['image'],
      json['birthday'],
      json['numberPhone'],
      json['address'],
      json['language'],
      articlesObject,
      vocabulariesObject,
    );
  }

  factory UserClient.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    final articlesObject = (data?['articles'] as List)
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();

    final vocabulariesObject = (data?['vocabularies'] as List)
        .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
        .toList();

    return UserClient(
      data?['id'] ?? "",
      data?['email'] ?? "",
      data?['password'] ?? "",
      data?['fullName'] ?? "",
      data?['image'] ?? "",
      data?['birthday'] ?? "",
      data?['numberPhone'] ?? "",
      data?['address'] ?? "",
      data?['language'] ?? "en",
      articlesObject,
      vocabulariesObject,
    );
  }

  Map<String, dynamic> toFirestore() {
    List<Map<String, dynamic>> articleMaps =
        articles!.map((article) => article.toJson()).toList();

    List<Map<String, dynamic>> vocabulariesMaps =
        vocabularies!.map((flashcard) => flashcard.toJson()).toList();

    return {
      "id": id ?? "",
      "email": email ?? "",
      "password": password ?? "",
      "fullName": fullName ?? "",
      "image": image ?? "",
      "birthday": birthday ?? "",
      "numberPhone": numberPhone ?? "",
      "address": address ?? "",
      "language": language ?? "en",
      "articles": articleMaps,
      "vocabularies": vocabulariesMaps,
    };
  }
}
