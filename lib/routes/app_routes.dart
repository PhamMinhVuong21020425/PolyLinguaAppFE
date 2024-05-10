import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_bindings.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_bindings.dart';
import 'package:poly_lingua_app/screens/flashcards/list_vocabulary_screen.dart';
import 'package:poly_lingua_app/screens/home/home_screen.dart';
import 'package:poly_lingua_app/screens/article/article_screen.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_home_screen.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_screen.dart';
import 'package:poly_lingua_app/screens/settings/settings_screen.dart';
import 'package:sqflite/sqflite.dart';

List<GetPage> getRoutes(Database database) {
  List<GetPage> routes = [
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(
      name: '/favorite',
      page: () => const FavoriteScreen(),
      binding: FavoriteBindings(),
    ),
    GetPage(name: '/settings', page: () => const SettingsScreen()),
    GetPage(name: '/flashcards', page: () => const FlashcardsHomeScreen()),
    GetPage(
      name: '/vocabulary',
      page: () => const FlashcardVocabularyScreen(),
      binding: FlashcardsBindings(),
    ),
    GetPage(
      name: '/article',
      page: () => ArticleScreen(database: database),
    ),
  ];

  return routes;
}
