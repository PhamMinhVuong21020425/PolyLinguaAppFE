import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/article/article_controller.dart';

class ArticleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleController>(() => ArticleController());
  }
}
