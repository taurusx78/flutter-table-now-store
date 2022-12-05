import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';
import 'package:table_now_store/util/jwtToken.dart';

// Provider는 서버와 통신하는 역할을 함

class UserProvider extends GetConnect {
  // 로그인
  Future<Response> login(Map data) => post(loginHost, data);

  // 인증번호 요청
  Future<Response> sendAuthNumber(String? email, String? phone) =>
      get('$host/send?email=$email&phone=$phone');

  // 아이디 찾기
  Future<Response> findId(Map data) => post('$host/find/id', data);
}
