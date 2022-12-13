import 'package:get/get.dart';
import 'package:table_now_store/controller/user/change_email_controller.dart';

class ChangeEmailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeEmailController());
  }
}
