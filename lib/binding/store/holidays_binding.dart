import 'package:get/get.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';

class HolidaysBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HolidaysController());
  }
}
