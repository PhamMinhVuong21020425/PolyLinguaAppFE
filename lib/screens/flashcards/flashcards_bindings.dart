import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';

class FlashcardsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashcardsController>(() => FlashcardsController());
  }
}
