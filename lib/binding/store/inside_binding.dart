import 'package:get/get.dart';
import 'package:table_now_store/controller/store/inside_controller.dart';

class InsideBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InsideController());
  }
}
