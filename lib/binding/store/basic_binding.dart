import 'package:get/get.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';

class BasicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BasicController());
  }
}
