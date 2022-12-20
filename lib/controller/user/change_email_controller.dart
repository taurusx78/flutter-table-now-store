import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/data/user/user_repository.dart';
import 'package:validators/validators.dart';

class ChangeEmailController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  final email = TextEditingController(); // 이메일
  final authNumber = TextEditingController(); // 인증번호

  final emailFormKey = GlobalKey<FormState>();
  final authNumberFormKey = GlobalKey<FormState>();
  final authNumberFocusNode = FocusNode();

  // 텍스트필드 입력 여부: 이메일/휴대폰번호 (0), 인증번호 (1)
  final List<RxBool> filled = [false.obs, false.obs];
  final RxBool clicked = false.obs; // 인증번호 받기 버튼이 눌렸는지

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    email.addListener(checkFilled);
    authNumber.addListener(checkFilled);
  }

  // 이메일 인증번호 요청
  Future<int> sendAuthNumber() async {
    return await _userRepository.sendAuthNumber(email.text, null);
  }

  // 이메일 인증번호 검증
  Future<int> verifyEmail() async {
    Map<String, String> data = {'authNumber': authNumber.text};
    return await _userRepository.verifyEmail(data);
  }

  // 이메일 변경
  Future<int> changeEmail() async {
    Map<String, String> data = {'email': email.text};
    int result = await _userRepository.changeEmail(data);
    return result;
  }

  // 텍스트필드 입력 여부
  void checkFilled() {
    // 이메일
    filled[0].value = isEmail(email.text);
    // 인증번호
    filled[1].value = authNumber.text.length == 6 && isNumeric(authNumber.text);
  }

  // 인증번호 받기 버튼 누른 경우
  void changeClicked(value) {
    clicked.value = value;
  }

  // 인증번호 텍스트필드 초기화
  void initializeAuthTextField() {
    authNumber.text = '';
  }
}
