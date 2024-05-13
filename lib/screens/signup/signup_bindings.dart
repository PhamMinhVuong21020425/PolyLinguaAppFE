import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/signup/signup_controller.dart';

class SignupBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
