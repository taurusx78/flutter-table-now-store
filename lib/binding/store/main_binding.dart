import 'package:get/get.dart';
import 'package:table_now_store/controller/store/main_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
