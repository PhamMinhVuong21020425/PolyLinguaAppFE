import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/article.dart';

class FavoriteController extends GetxController {
  FavoriteController();

  final articleList = [].obs;

  final currentIndex = 0.obs;

  void toggleFavorite(Article article) {
    if (article.isFavorite) {
      articleList.insert(0, article);
    } else {
      articleList.remove(article);
    }
  }
}
