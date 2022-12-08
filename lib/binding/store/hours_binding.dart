import 'package:get/get.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';

class HoursBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HoursController());
  }
}
