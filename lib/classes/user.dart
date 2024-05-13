import 'package:cloud_firestore/cloud_firestore.dart';

class UserClient {
  final String? id;
  final String? image;
  final String? fullName;
  final String? birthday;
  final String? email;
  final String? password;
  final String? numberPhone;

  UserClient(
    this.id,
    this.image,
    this.fullName,
    this.birthday,
    this.email,
    this.password,
    this.numberPhone,
  );

  factory UserClient.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserClient(
      data?['id'] ?? "",
      data?['image'] ?? "",
      data?['fullName'] ?? "",
      data?['birthday'] ?? "",
      data?['email'] ?? "",
      data?['password'] ?? "",
      data?['numberPhone'] ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ?? "",
      "image": image ?? "",
      "fullName": fullName ?? "",
      "birthday": birthday ?? "",
      "email": email ?? "",
      "password": password ?? "",
      "numberPhone": numberPhone ?? ""
    };
  }
}
