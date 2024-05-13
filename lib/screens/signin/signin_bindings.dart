import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/signin/signin_controller.dart';

class SigninBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninController>(() => SigninController());
  }
}
