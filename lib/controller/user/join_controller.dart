import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/data/user/user_repository.dart';

class JoinController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // 약관 동의 여부 (전체 (0), 첫번째 (1), 두번째 (2))
  List<RxBool> agreed = [false.obs, false.obs, false.obs];
  // 전체 약관 동의 여부 (첫번째 (1), 두번째 (2), 전체 (3))
  final RxInt allAgreed = 0.obs;

  final RxBool loaded = true.obs; // 조회 완료 여부
  final RxBool canJoin = false.obs; // 가입 가능 여부
  final RxString name = ''.obs; // 이름
  final RxString phone = ''.obs; // 휴대폰번호
  final RxString uniqueKey = ''.obs; // 개인고유식별키

  final username = TextEditingController();
  final password = TextEditingController();
  final passwordCheck = TextEditingController();
  final email = TextEditingController();
  final authNumber = TextEditingController();

  final usernameFormKey = GlobalKey<FormState>();
  final pwFormKey = GlobalKey<FormState>();
  final pwCheckFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final authNumberFormKey = GlobalKey<FormState>();
  final authNumberFocusNode = FocusNode();

  // 아이디 중복확인 여부 (확인전 (-1), 사용가능 (0), 이미 사용중 (1))
  final RxInt usernameState = (-1).obs;
  final RxBool emailClicked = false.obs; // 이메일 인증받기 버튼이 눌렸는지
  final RxBool emailVerified = false.obs; // 이메일 인증완료 여부

  // 가입 여부 조회
  Future<int> checkJoined() async {
    loaded.value = false;
    Map<String, String> data = {'uniqueKey': uniqueKey.value};
    int result = await _userRepository.checkJoined(data);
    loaded.value = true;
    return result;
  }

  // 아이디 중복확인
  Future<void> checkUsername() async {
    int result = await _userRepository.checkUsername(username.text);
    changeUsernameState(result);
  }

  // 약관 동의 여부 변경
  void changeAgreed(int index, bool value) {
    if (index == 0) {
      // 전체 약관 동의 여부
      if (value) {
        // 동의함
        allAgreed.value = 3;
        for (int i = 0; i < agreed.length; i++) {
          agreed[i].value = true;
        }
      } else {
        // 동의하지 않음
        allAgreed.value = 0;
        for (int i = 0; i < agreed.length; i++) {
          agreed[i].value = false;
        }
      }
    } else {
      agreed[index].value = value;
      if (value) {
        // 동의함
        allAgreed.value += index;
      } else {
        // 동의하지 않음
        allAgreed.value -= index;
      }
      agreed[0].value = allAgreed.value == 3;
    }
  }

  // 가입 가능 여부 변경
  void changeCanJoin(value) {
    canJoin.value = value;
  }

  // 본인인증된 사용자 정보 설정
  void setUserInfo(String name, String phone, String uniqueKey) {
    this.name.value = name;
    this.phone.value = phone;
    this.uniqueKey.value = uniqueKey;
  }

  // 회원가입 아이디, 이메일 상태 초기화
  void initializeAllState() {
    usernameState.value = -1;
    emailClicked.value = false;
    emailVerified.value = false;
  }

  // 아이디 중복확인 여부 변경
  void changeUsernameState(int value) {
    usernameState.value = value;
  }
}
