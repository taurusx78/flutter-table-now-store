import 'package:get/get.dart';
import 'package:table_now_store/controller/store/delete_store_controller.dart';

class DeleteStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeleteStoreController());
  }
}
