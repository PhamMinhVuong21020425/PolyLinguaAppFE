import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/home/home_screen.dart';
import 'package:poly_lingua_app/screens/article/article_screen.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_screen.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_screen.dart';
import 'package:poly_lingua_app/screens/settings/settings_screen.dart';
import 'package:poly_lingua_app/classes/article.dart';

var article = Article(
    title: "Scientists Discover New Species of Orchid in Amazon Rain forest",
    description:
        "Researchers have identified a previously unknown species of orchid deep in the Amazon rain forest.",
    url: "https://example.com/article1",
    image:
        "https://images.photowall.com/products/60514/fresh-green-tree.jpg?h=699&q=85",
    publishedAt: DateTime.parse("2024-03-20T12:00:00.000Z"),
    content:
        "10日のニューヨーク外国為替市場では、この日発表されたアメリカの先月の消費者物価指数の上昇率が市場予想を上回ったことで、市場ではFRB...",
    language: "ja");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Poly Lingua App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Định nghĩa tuyến đường ban đầu
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/article', page: () => const ArticleScreen()),
        GetPage(name: '/flashcards', page: () => const FlashcardsScreen()),
        GetPage(name: '/favorite', page: () => const FavoriteScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
