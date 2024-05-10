import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_controller.dart';

class FavoriteBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}
