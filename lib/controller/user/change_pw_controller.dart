import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/user/change_pw_req_dto.dart';
import 'package:table_now_store/controller/dto/user/reset_pw_req_dto.dart';
import 'package:table_now_store/data/user/user_repository.dart';

// 비밀번호 변경 또는 재설정을 수행하는 Controller

class ChangePwController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  final curPassword = TextEditingController();
  final newPassword = TextEditingController();
  final newPasswordCheck = TextEditingController();

  final curPwFormKey = GlobalKey<FormState>();
  final newPwFormKey = GlobalKey<FormState>();
  final newPwCheckFormKey = GlobalKey<FormState>();

  // 텍스트필드 입력 여부: 현재 비밀번호 (0), 새 비밀번호 (1), 새 비밀번호 확인 (2)
  List<RxBool> filled = [false.obs, false.obs, false.obs];

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    curPassword.addListener(checkFilled);
    newPassword.addListener(checkFilled);
    newPasswordCheck.addListener(checkFilled);
  }

  // 비밀번호 재설정 (비밀번호 찾기)
  Future<int> resetPassword(String username, String authNumber) async {
    ResetPwReqDto dto = ResetPwReqDto(
      username: username,
      newPassword: newPassword.text,
      authNumber: authNumber,
    );
    return await _userRepository.resetPassword(dto.toJson());
  }

  // 비밀번호 변경
  Future<int> changePassword() async {
    ChangePwReqDto dto = ChangePwReqDto(
      curPassword: curPassword.text,
      newPassword: newPassword.text,
    );
    return await _userRepository.changePassword(dto.toJson());
  }

  // 텍스트필드 입력 여부
  void checkFilled() {
    // 현재 비밀번호
    filled[0].value = curPassword.text.length >= 8;

    // 새 비밀번호
    // 영어 대소문자, 숫자, 특수문자를 포함한 8~20자
    Pattern pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,20}$';
    RegExp regExp = RegExp(pattern.toString());
    filled[1].value = regExp.hasMatch(newPassword.text);

    // 새 비밀번호 확인
    filled[2].value = newPassword.text == newPasswordCheck.text;
  }
}
