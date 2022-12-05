import 'package:get/get.dart';
import 'package:table_now_store/controller/user/join_controller.dart';

class JoinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinController());
  }
}
