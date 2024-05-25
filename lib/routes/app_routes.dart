import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_bindings.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_bindings.dart';
import 'package:poly_lingua_app/screens/flashcards/english_vocabulary_screen.dart';
import 'package:poly_lingua_app/screens/flashcards/japanese_vocabulary_screen.dart';
import 'package:poly_lingua_app/screens/flashcards/star_vocabulary_screen.dart';
import 'package:poly_lingua_app/screens/home/home_screen.dart';
import 'package:poly_lingua_app/screens/article/article_screen.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_home_screen.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_screen.dart';
import 'package:poly_lingua_app/screens/settings/change_password.dart';
import 'package:poly_lingua_app/screens/settings/notifications.dart';
import 'package:poly_lingua_app/screens/settings/edit_profile.dart';
import 'package:poly_lingua_app/screens/settings/settings_screen.dart';
import 'package:poly_lingua_app/screens/signin/signin_bindings.dart';
import 'package:poly_lingua_app/screens/signin/signin_screen.dart';
import 'package:poly_lingua_app/screens/signup/signup_bindings.dart';
import 'package:poly_lingua_app/screens/signup/signup_screen.dart';
import 'package:sqflite/sqflite.dart';

List<GetPage> getRoutes(Database database) {
  List<GetPage> routes = [
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/favorite',
      page: () => const FavoriteScreen(),
      binding: FavoriteBindings(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: '/flashcards',
      page: () => const FlashcardsHomeScreen(),
    ),
    GetPage(
      name: '/vocabulary/star',
      page: () => const StarVocabularyScreen(),
      binding: FlashcardsBindings(),
    ),
    GetPage(
      name: '/vocabulary/english',
      page: () => const EnglishVocabularyScreen(),
      binding: FlashcardsBindings(),
    ),
    GetPage(
      name: '/vocabulary/japanese',
      page: () => const JapaneseVocabularyScreen(),
      binding: FlashcardsBindings(),
    ),
    GetPage(
      name: '/article',
      page: () => ArticleScreen(database: database),
    ),
    GetPage(
      name: '/signin',
      page: () => const SigninScreen(),
      binding: SigninBindings(),
    ),
    GetPage(
      name: '/signup',
      page: () => const SignupScreen(),
      binding: SignupBindings(),
    ),
    GetPage(
      name: '/change-password',
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: '/profile',
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotificationsScreen(),
    ),
  ];

  return routes;
}
