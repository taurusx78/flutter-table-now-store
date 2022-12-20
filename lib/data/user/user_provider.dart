import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';
import 'package:table_now_store/util/jwtToken.dart';

// Provider는 서버와 통신하는 역할을 함

class UserProvider extends GetConnect {
  // 로그인
  Future<Response> login(Map data) => post(loginHost, data);

  // 회원가입
  Future<Response> join(Map data) => post('$host/join', data);

  // 인증번호 요청
  Future<Response> sendAuthNumber(String? email, String? phone) {
    if (email != null) {
      return get('$host/send?email=$email');
    } else {
      return get('$host/send?phone=$phone');
    }
  }

  // 아이디 찾기
  Future<Response> findId(Map data) => post('$host/find/id', data);

  // 비밀번호 찾기
  Future<Response> findPassword(Map data) => post('$host/find/password', data);

  // 비밀번호 재설정
  Future<Response> resetPassword(Map data) => put('$host/reset/password', data);

  // 가입 여부 조회
  Future<Response> checkJoined(Map data) => post('$host/check/user', data);

  // 아이디 중복확인
  Future<Response> checkUsername(String username) =>
      get('$host/check?username=$username');

  // 이메일 인증번호 검증 (회원가입, 이메일 변경)
  Future<Response> verifyEmail(Map data) => post('$host/verify/email', data);

  // 비밀번호 변경
  Future<Response> changePassword(Map data) => put(
        '$host/manager/password',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 이메일 변경
  Future<Response> changeEmail(Map data) => put(
        '$host/manager/email',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 회원탈퇴
  Future<Response> withdrawal(Map data) => post(
        '$host/manager/withdrawal',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );
}
