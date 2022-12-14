import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/data/user/user_repository.dart';

class WithdrawalController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  final password = TextEditingController();
  final pwFormKey = GlobalKey<FormState>();
  final RxString selectedReason = ''.obs;
  final RxBool filled = false.obs;

  // 탈퇴 사유 목록
  final List<String> reasons = [
    '11111',
    '22222',
    '33333',
    '44444',
    '55555',
  ];

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    password.addListener(checkFilled);
  }

  // 회원탈퇴
  Future<String?> withdrawal() async {
    Map<String, String> data = {'password': password.text};
    String? name = await _userRepository.withdrawal(data);
    return name;
  }

  // 선택된 탈퇴 이유 변경
  void changeSelectedReason(String value) {
    selectedReason.value = value;
  }

  // 텍스트필드 입력 여부 변경
  void checkFilled() {
    filled.value = password.text.length >= 8;
  }
}
