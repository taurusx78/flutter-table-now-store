import 'package:get/get.dart';
import 'package:table_now_store/controller/user/withdrawal_controller.dart';

class WithdrawalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithdrawalController());
  }
}
