import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';
import 'package:table_now_store/util/jwtToken.dart';

// Provider는 서버와 통신하는 역할을 함

class UserProvider extends GetConnect {
  // 로그인
  Future<Response> login(Map data) async => await post(loginHost, data);

  // 회원가입
  Future<Response> join(Map data) async => await post('$host/join', data);

  // 인증번호 요청
  Future<Response> sendAuthNumber(String? email, String? phone) async {
    if (email != null) {
      return await get('$host/send?email=$email');
    } else {
      return await get('$host/send?phone=$phone');
    }
  }

  // 아이디 찾기
  Future<Response> findId(Map data) async => await post('$host/find/id', data);

  // 비밀번호 찾기
  Future<Response> findPassword(Map data) async =>
      await post('$host/find/password', data);

  // 비밀번호 재설정
  Future<Response> resetPassword(Map data) async =>
      await put('$host/reset/password', data);

  // 가입 여부 조회
  Future<Response> checkJoined(Map data) async =>
      await post('$host/check/user', data);

  // 아이디 중복확인
  Future<Response> checkUsername(String username) async =>
      await get('$host/check?username=$username');

  // 이메일 인증번호 검증 (회원가입, 이메일 변경)
  Future<Response> verifyEmail(Map data) async =>
      await post('$host/verify/email', data);

  // 비밀번호 변경
  Future<Response> changePassword(Map data) async => await put(
        '$host/manager/password',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 이메일 변경
  Future<Response> changeEmail(Map data) async => await put(
        '$host/manager/email',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 회원탈퇴
  Future<Response> withdrawal(Map data) async => await post(
        '$host/manager/withdrawal',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );
}
