import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/controller/dto/user/find_id_resp_dto.dart';
import 'package:table_now_store/data/user/user.dart';
import 'package:table_now_store/data/user/user_provider.dart';
import 'package:table_now_store/util/jwtToken.dart';

// Repository는 서버로부터 응답받은 데이터를 JSON에서 Dart 오브젝트로 변경하는 역할을 함

class UserRepository {
  final UserProvider _userProvider = UserProvider();
  SharedPreferences? pref; // 인증토큰 내부저장소에 저장

  // 로그인
  Future<int> login(Map data) async {
    Response response = await _userProvider.login(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        // (주의) 'Authorization' 표기 시 에러남
        String token = response.headers!['authorization']!;
        print('토큰: ' + token);

        // 로컬저장소에 토큰 저장 (앱이 꺼져도 토큰 유효시간 동안 로그인 유지)
        pref = await SharedPreferences.getInstance();
        pref!.setString('token', token);
        jwtToken = token;

        // 로컬저장소에 로그인한 사용자 정보 저장
        CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
        User user = User.fromJson(codeMsgRespDto.response);
        pref!.setStringList(
            'user', [user.username, user.name, user.phone, user.email]);
      }
      return dto.code; // 로그인 성공 (200), 실패 (400)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 회원가입
  Future<int> join(Map data) async {
    Response response = await _userProvider.join(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 회원가입 완료 (201)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 인증번호 요청
  Future<int> sendAuthNumber(String? email, String? phone) async {
    Response response = await _userProvider.sendAuthNumber(email, phone);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 요청 완료 (200)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 아이디 찾기
  Future<dynamic> findId(Map data) async {
    Response response = await _userProvider.findId(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        if (dto.message == '아이디 찾기 성공') {
          dynamic temp = dto.response;
          return FindIdRespDto.fromJson(temp); // 일치 회원 존재 (FindIdRespDto)
        }
      }
      return dto.code; // 일치 회원 없음 (200), 인증 실패 (401)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 비밀번호 찾기
  Future<dynamic> findPassword(Map data) async {
    Response response = await _userProvider.findPassword(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return dto.message; // 인증 성공
      }
      return dto.code; // 인증 실패 (401)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 비밀번호 재설정
  Future<int> resetPassword(Map data) async {
    Response response = await _userProvider.resetPassword(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 재설정 완료 (200), 인증 실패 (401)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 가입 여부 조회
  Future<int> checkJoined(Map data) async {
    Response response = await _userProvider.checkJoined(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return dto.response; // 회원 존재 (1), 가입 가능 (0)
      }
      return dto.code;
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 아이디 중복확인
  Future<int> checkUsername(String username) async {
    Response response = await _userProvider.checkUsername(username);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 1) {
        return dto.response; // 이미 사용중 (1), 사용가능 (0)
      }
      return dto.code;
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 이메일 인증번호 검증 (회원가입, 이메일 변경)
  Future<int> verifyEmail(Map data) async {
    Response response = await _userProvider.verifyEmail(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 인증 성공 (200), 인증 실패 (401)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 비밀번호 변경
  Future<int> changePassword(Map data) async {
    Response response = await _userProvider.changePassword(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 변경 완료 (200), 인증 실패 (401), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 이메일 변경
  Future<int> changeEmail(Map data) async {
    Response response = await _userProvider.changeEmail(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 변경 완료 (200), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 회원탈퇴
  Future<int> withdrawal(Map data) async {
    Response response = await _userProvider.withdrawal(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 탈퇴 완료 (200), 인증 실패 (401), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }
}
