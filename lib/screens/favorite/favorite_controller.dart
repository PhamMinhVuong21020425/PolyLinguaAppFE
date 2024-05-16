import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class FavoriteController extends GetxController {
  FavoriteController();

  List<Article> articleList = <Article>[].obs;

  @override
  void onInit() {
    super.onInit();
    UserController userController = Get.find<UserController>();
    articleList = userController.user?.articles ?? [];
  }

  void toggleFavorite(Article article, bool isFavorite) {
    if (isFavorite) {
      articleList.insert(0, article);
    } else {
      articleList.removeWhere((element) => element.title == article.title);
    }
    UserController userController = Get.find<UserController>();

    userController.updateUser(articles: articleList);
  }
}
