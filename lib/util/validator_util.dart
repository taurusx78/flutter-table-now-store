import 'package:validators/validators.dart';

// 회원 이메일 유효성 검사
Function validateEmail() {
  return (String? value) {
    if (!isEmail(value!)) {
      return '올바른 이메일 형식으로 입력해 주세요.';
    } else {
      return null;
    }
  };
}

// 회원 휴대폰번호 유효성 검사
Function validateUserPhone() {
  return (String? value) {
    if (!isNumeric(value!) || value.length < 10 || value.length > 11) {
      return '- 를 제외한 10~11자의 숫자로 입력해 주세요.';
    } else {
      return null;
    }
  };
}

// 인증번호 유효성 검사
Function validateAuthNumber() {
  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (value.length != 6 || !isNumeric(value)) {
      return '인증번호는 6자리 숫자입니다.';
    } else {
      return null;
    }
  };
}
