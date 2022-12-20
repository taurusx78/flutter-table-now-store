import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_now_store/controller/dto/user/login_req_dto.dart';
import 'package:table_now_store/data/user/user_repository.dart';
import 'package:table_now_store/util/jwtToken.dart';

// Controller는 View와 통신하는 역할을 함

class LoginController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  SharedPreferences? pref; // 인증토큰 내부저장소에 저장

  final username = TextEditingController();
  final password = TextEditingController();

  final RxBool activated = false.obs; // 로그인 버튼 활성화 여부
  final RxBool loaded = true.obs; // 로그인 요청 처리 완료 여부

  @override
  void onInit() {
    super.onInit();
    // *** 이미 유효한 토큰을 가지고 있으면 메인페이지로 이동!
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    username.addListener(checkButtonActivated);
    password.addListener(checkButtonActivated);
  }

  // 로그인
  Future<int> login() async {
    loaded.value = false;
    LoginReqDto dto = LoginReqDto(username.text.trim(), password.text);
    int result = await _userRepository.login(dto.toJson());
    loaded.value = true;
    return result;
  }

  // 로그아웃
  Future<void> logout() async {
    pref = await SharedPreferences.getInstance();
    pref!.remove('token'); // 토큰 삭제
    pref!.remove('user'); // 로그인한 사용자 정보 삭제
    jwtToken = null; // 토큰 변수 초기화
  }

  // 로그인 버튼 활성화 여부 확인
  void checkButtonActivated() {
    // 아이디 4~20자, 비밀번호 8~20자로 입력된 경우, 버튼 활성화
    activated.value =
        username.text.trim().length >= 4 && password.text.length >= 8;
  }

  // 텍스트필드 초기화
  void initializeTextField() {
    username.text = '';
    password.text = '';
  }
}
