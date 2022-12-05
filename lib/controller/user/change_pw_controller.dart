import 'package:get/get.dart';
import 'package:table_now_store/data/user/user_repository.dart';

// 비밀번호 변경 또는 재설정을 수행하는 Controller

class ChangePwController extends GetxController {
  final UserRepository _userRepository = UserRepository();
}
