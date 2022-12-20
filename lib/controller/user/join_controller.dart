import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/user/join_req_dto.dart';
import 'package:table_now_store/data/user/user_repository.dart';

class JoinController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // 약관 동의 여부 (전체 (0), 첫번째 (1), 두번째 (2))
  List<RxBool> agreed = [false.obs, false.obs, false.obs];
  // 전체 약관 동의 여부 (첫번째 (1), 두번째 (2), 전체 (3))
  final RxInt allAgreed = 0.obs;

  final RxBool loaded = true.obs; // 조회 완료 여부
  final RxBool userCanJoin = false.obs; // 사용자 가입 가능 여부
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
  Future<int> checkUsername() async {
    int result = await _userRepository.checkUsername(username.text);
    if (result != -3) {
      usernameState.value = result;
    }
    return result;
  }

  // 이메일 인증번호 요청
  Future<int> sendAuthNumber() async {
    return await _userRepository.sendAuthNumber(email.text, null);
  }

  // 이메일 인증번호 검증
  Future<int> verityEmail() async {
    Map<String, String> data = {'authNumber': authNumber.text};
    return await _userRepository.verifyEmail(data);
  }

  // 회원가입
  Future<int> join() async {
    JoinReqDto dto = JoinReqDto(
      username: username.text,
      password: password.text,
      name: name.value,
      phone: phone.value,
      uniqueKey: uniqueKey.value,
      email: email.text,
    );
    return await _userRepository.join(dto.toJson());
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

  // 사용자 가입 가능 여부 변경
  void changeUserCanJoin(value) {
    userCanJoin.value = value;
  }

  // 본인인증된 사용자 정보 설정
  void setUserInfo(String name, String phone, String uniqueKey) {
    this.name.value = name;
    this.phone.value = phone;
    this.uniqueKey.value = uniqueKey;
  }

  // 회원가입 폼 초기화
  void initializeJoinForm() {
    username.text = '';
    password.text = '';
    passwordCheck.text = '';
    email.text = '';
    authNumber.text = '';

    usernameState.value = -1;
    emailClicked.value = false;
    emailVerified.value = false;
  }

  // 아이디 중복확인 여부 초기화
  void initializeUsernameState() {
    username.text = '';
    usernameState.value = -1;
  }

  // 이메일 인증받기 버튼 클릭됨
  void changeEmailClicked() {
    emailClicked.value = true;
  }

  // 이메일 인증 여부 초기화
  void initializeEmailAuth() {
    email.text = '';
    authNumber.text = '';
    emailClicked.value = false;
    emailVerified.value = false;
  }

  // 이메일 인증완료
  void changeEmailVerified() {
    emailVerified.value = true;
  }

  // 인증번호 텍스트필드 초기화
  void initializeAuthTextField() {
    authNumber.text = '';
  }
}
