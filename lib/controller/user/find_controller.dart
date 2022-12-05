import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/user/find_id_req_dto.dart';
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

  // 텍스트필드 입력 여부: 이메일/휴대폰번호 (0), 아이디 (1) 인증번호 (2)
  List<RxBool> filled = [false.obs, false.obs, false.obs];
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
    String email = '';
    String phone = '';
    if (method.value == 1) {
      email = data.text;
    } else if (method.value == 2) {
      phone = data.text;
    }
    return await _userRepository.sendAuthNumber(email, phone);
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
  // Future<int> findPassword(String method) async {
  //   if (method == 'phone') {
  //     data.text = data.text.replaceAll('-', '');
  //   }
  //   FindPwReq dto = FindPwReq(
  //     method: method,
  //     data: data.text.trim(),
  //     username: username.text.trim(),
  //     authNumber: authNumber.text,
  //   );
  //   return await _userRepository.findPassword(dto.toJson());
  // }

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
      filled[0].value = isEmail(data.text);
    } else if (method.value == 2) {
      filled[0].value = isNumeric(data.text) &&
          data.text.length >= 10 &&
          data.text.length <= 11;
    }

    // 아이디
    filled[1].value =
        username.text.length >= 4 && isAlphanumeric(username.text);

    // 인증번호
    filled[2].value = authNumber.text.length == 6 && isNumeric(authNumber.text);
  }

  // 인증번호 텍스트필드 초기화
  void clearAuthTextField() {
    authNumber.text = '';
  }
}
