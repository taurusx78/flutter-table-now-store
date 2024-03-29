import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/user/find_id_req_dto.dart';
import 'package:table_now_store/controller/dto/user/find_pw_req_dto.dart';
import 'package:table_now_store/data/user/user_repository.dart';
import 'package:validators/validators.dart';

class FindController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // 인증방법: 미선택 (0), 이메일 (1), 휴대폰번호 (2)
  final RxInt method = 0.obs;

  final data = TextEditingController(); // 이메일 또는 휴대폰번호
  final username = TextEditingController(); // 아이디
  final authNumber = TextEditingController(); // 인증번호

  final dataFormKey = GlobalKey<FormState>();
  final usernameFormKey = GlobalKey<FormState>();
  final authNumberFormKey = GlobalKey<FormState>();
  final authNumberFocusNode = FocusNode();

  // 텍스트필드 입력 여부: 이메일/휴대폰번호 (0), 아이디 (1), 인증번호 (2)
  List<RxBool> filled = [false.obs, false.obs, false.obs];
  final RxBool sent = true.obs; // 인증번호가 전송됐는지
  final RxBool clicked = false.obs; // 인증번호 받기 버튼이 눌렸는지

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    data.addListener(checkFilled);
    username.addListener(checkFilled);
    authNumber.addListener(checkFilled);
  }

  // 인증번호 요청
  Future<int> sendAuthNumber() async {
    sent.value = false;
    String email = '';
    String phone = '';
    if (method.value == 1) {
      email = data.text;
    } else if (method.value == 2) {
      phone = data.text;
    }
    int result = await _userRepository.sendAuthNumber(email, phone);
    sent.value = true;
    return result;
  }

  // 아이디 찾기
  Future<dynamic> findId(String method) async {
    FindIdReqDto dto = FindIdReqDto(
      method: method,
      data: data.text,
      authNumber: authNumber.text,
    );
    return await _userRepository.findId(dto.toJson());
  }

  // 비밀번호 찾기
  Future<dynamic> findPassword(String method) async {
    FindPwReqDto dto = FindPwReqDto(
      method: method,
      data: data.text,
      username: username.text,
      authNumber: authNumber.text,
    );
    return await _userRepository.findPassword(dto.toJson());
  }

  // 인증방법 변경
  void changeMethod(int index) {
    method.value = index;
  }

  // 전체 상태 초기화
  void initializeAllState() {
    method.value = 0;
    data.text = '';
    username.text = '';
    authNumber.text = '';
    clicked.value = false;
    sent.value = true;
    filled = [false.obs, false.obs, false.obs];
  }

  // 인증번호 받기 버튼 클릭 여부
  void changeClicked(value) {
    clicked.value = value;
  }

  // 텍스트필드 입력 여부
  void checkFilled() {
    // 이메일 또는 휴대폰번호
    if (method.value == 1) {
      Pattern pattern = r'^[\w-_]+@[\w-_\.]+\.[A-z]{2,6}$';
      filled[0].value = RegExp(pattern.toString()).hasMatch(data.text);
    } else if (method.value == 2) {
      Pattern pattern = r'^01(0|1|[6-9])\d{3,4}\d{4}$';
      filled[0].value = RegExp(pattern.toString()).hasMatch(data.text);
    }

    // 아이디
    Pattern pattern = r'^(?=.*[a-z])[a-z\d]{4,20}$';
    filled[1].value = RegExp(pattern.toString()).hasMatch(username.text);

    // 인증번호
    filled[2].value = authNumber.text.length == 6 && isNumeric(authNumber.text);
  }

  // 인증번호 텍스트필드 초기화
  void clearAuthTextField() {
    authNumber.text = '';
  }
}
