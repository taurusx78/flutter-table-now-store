import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';

class SaveNoticeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaveNoticeController());
  }
}
