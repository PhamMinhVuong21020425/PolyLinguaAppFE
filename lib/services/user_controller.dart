import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/classes/user.dart';

class UserController extends GetxController {
  final Rx<UserClient?> _user = Rx<UserClient?>(null);
  UserClient? get user => _user.value;

  void setUser(UserClient? user) {
    _user.value = user;
    update();
  }

  void updateUser({
    String? password,
    String? fullName,
    String? image,
    String? birthday,
    String? numberPhone,
    String? address,
    String? language,
    List<Article>? articles,
    List<Flashcard>? vocabularies,
  }) async {
    UserClient user = UserClient(
      _user.value?.id,
      _user.value?.email,
      password ?? _user.value?.password,
      fullName ?? _user.value?.fullName,
      image ?? _user.value?.image,
      birthday ?? _user.value?.birthday,
      numberPhone ?? _user.value?.numberPhone,
      address ?? _user.value?.address,
      language ?? _user.value?.language,
      articles ?? _user.value?.articles,
      vocabularies ?? _user.value?.vocabularies,
    );

    _user.value = user;

    // Update the user in the database
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').doc(user.id).set(user.toFirestore());

    update();
  }
}
