import 'package:get/get.dart';
import 'package:table_now_store/controller/user/change_pw_controller.dart';
import 'package:table_now_store/controller/user/join_controller.dart';
import 'package:validators/validators.dart';

// 회원 이메일 유효성 검사
Function validateEmail() {
  Pattern pattern = r'^[\w-_]+@[\w-_\.]+\.[A-z]{2,6}$';
  RegExp regExp = RegExp(pattern.toString());

  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (!regExp.hasMatch(value)) {
      return '올바른 이메일 형식으로 입력해 주세요.';
    } else {
      return null; // 유효성 검사 통과한 경우
    }
  };
}

// 회원 휴대폰번호 유효성 검사
Function validateUserPhone() {
  Pattern pattern = r'^01(0|1|[6-9])\d{3,4}\d{4}$';
  RegExp regExp = RegExp(pattern.toString());

  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (!isNumeric(value)) {
      return '- 를 제외한 숫자로 입력해 주세요.';
    } else {
      if (!regExp.hasMatch(value)) {
        return '휴대폰 번호 형식이 올바르지 않습니다.';
      }
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

// 아이디 유효성 검사
Function validateUsername() {
  return (String? value) {
    // 영어 소문자, 숫자로 구성된 4~20자
    Pattern pattern = r'^(?=.*[a-z])[a-z\d]{4,20}$';
    RegExp regExp = RegExp(pattern.toString());

    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (!regExp.hasMatch(value)) {
      return '영어 소문자, 숫자로 구성된 4~20자로 입력해 주세요.';
    } else {
      return null;
    }
  };
}

// 현재 비밀번호 유효성 검사 (비밀번호 변경)
Function validateCurPassword() {
  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (value.length < 8) {
      return '비밀번호는 8~20자로 입력해 주세요.';
    } else {
      return null;
    }
  };
}

// 새 비밀번호 유효성 검사
Function validateNewPassword(String? curPassword) {
  return (String? value) {
    // 영어 대소문자, 숫자, 특수문자를 포함한 8~20자
    Pattern pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,20}$';
    RegExp regExp = RegExp(pattern.toString());

    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (curPassword != null && curPassword == value) {
      return '현재 비밀번호와 다른 새 비밀번호를 입력해 주세요.';
    } else if (!regExp.hasMatch(value)) {
      return '영어 대소문자, 숫자, 특수문자를 포함한 8~20자로 입력해 주세요.';
    } else {
      return null;
    }
  };
}

// 비밀번호 확인 유효성 검사 (비밀번호 변경 및 재설정 시)
Function validatePasswordCheck() {
  return (String? value) {
    ChangePwController controller = Get.find();
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (value != controller.newPassword.text) {
      return '비밀번호가 서로 일치하지 않습니다.';
    } else {
      return null;
    }
  };
}

// 비밀번호 확인 유효성 검사 (회원가입 시)
Function validateJoinPasswordCheck() {
  return (String? value) {
    JoinController controller = Get.find();
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (value != controller.password.text) {
      return '비밀번호가 서로 일치하지 않습니다.';
    } else {
      return null;
    }
  };
}

// 매장 전화번호 유효성 검사
Function validateStorePhone() {
  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (!isNumeric(value)) {
      return '전화번호는 - 를 제외한 숫자로 입력해 주세요.';
    } else if (value.length < 7 || value.length > 8) {
      return '전화번호 길이가 너무 짧습니다.';
    } else {
      return null;
    }
  };
}

// 매장 주소 유효성 검사
Function validateStoreAddress() {
  return (String? value) {
    Pattern pattern = r'^([가-힣]|\w|[,-]|\s){2,50}$';
    RegExp regExp = RegExp(pattern.toString());

    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else if (!regExp.hasMatch(value)) {
      return '주소 형식이 올바르지 않습니다.';
    } else {
      return null;
    }
  };
}

// URL 유효성 검사
Function validateWebsite() {
  Pattern pattern =
      r'(https?:\/\/)?(www\.)?[\w@:%.-_\+~#=]{2,256}\.[a-z]{2,6}\b([\w@:%-_\+.~#?&//=]*)|()';
  RegExp regExp = RegExp(pattern.toString());

  return (String? value) {
    if (!regExp.hasMatch(value!)) {
      return '올바른 URL 형식으로 입력해 주세요.';
    }
    return null;
  };
}

// 텍스트필드 공백 여부 유효성 검사
Function validateTextField() {
  return (String? value) {
    if (value!.isEmpty) {
      return '필수항목 입니다.';
    } else {
      return null;
    }
  };
}
