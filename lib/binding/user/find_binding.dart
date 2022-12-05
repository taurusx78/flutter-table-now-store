import 'package:get/get.dart';
import 'package:table_now_store/controller/user/find_controller.dart';

class FindBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FindController());
  }
}
