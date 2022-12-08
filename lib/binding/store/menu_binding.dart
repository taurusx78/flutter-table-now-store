import 'package:get/get.dart';
import 'package:table_now_store/controller/store/menu_controller.dart';

class MenuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuController());
  }
}
