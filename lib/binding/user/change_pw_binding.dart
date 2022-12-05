import 'package:get/get.dart';
import 'package:table_now_store/controller/user/change_pw_controller.dart';

class ChangePwBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePwController());
  }
}
