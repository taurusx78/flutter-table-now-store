import 'package:get/get.dart';
import 'package:table_now_store/controller/user/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
