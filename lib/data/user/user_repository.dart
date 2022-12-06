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
  Future<String> login(Map data) async {
    Response response = await _userProvider.login(data);
    dynamic headers = response.headers;
    String result = '';

    if (headers != null) {
      // (주의) 'Authorization' 표기 시 에러남
      if (headers['authorization'] != null) {
        result = headers['authorization'];
        print('토큰: ' + result);

        // 로컬저장소에 토큰 저장 (앱이 꺼져도 토큰 유효시간 동안 로그인 유지)
        pref = await SharedPreferences.getInstance();
        pref!.setString('token', result);
        jwtToken = result;

        // 로컬저장소에 로그인한 사용자 정보 저장
        CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
        User user = User.fromJson(codeMsgRespDto.response);
        pref!.setStringList(
            'user', [user.username, user.name, user.phone, user.email]);
      } else {
        result = '아이디 또는 비밀번호가 일치하지 않습니다.'; // 로그인 실패
      }
    } else {
      result = '네트워크 연결을 확인해 주세요.'; // 네트워크 연결 안됨
    }
    return result;
  }

  // 인증번호 요청
  Future<int> sendAuthNumber(String? email, String? phone) async {
    Response response = await _userProvider.sendAuthNumber(email, phone);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code;
  }

  // 아이디 찾기
  Future<dynamic> findId(Map data) async {
    Response response = await _userProvider.findId(data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      // 1. 인증 성공 & 회원 존재
      dynamic temp = codeMsgRespDto.response;
      return FindIdRespDto.fromJson(temp);
    } else {
      // 2. 인증 성공 & 회원 없음 (0)
      // 3. 인증 실패 (-1)
      return codeMsgRespDto.code;
    }
  }

  // 비밀번호 찾기
  Future<int> findPassword(Map data) async {
    Response response = await _userProvider.findPassword(data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code; // 회원존재 (1), 회원없음 (0), 인증실패 (-1)
  }

  // 비밀번호 재설정
  Future<int> resetPassword(Map data) async {
    Response response = await _userProvider.resetPassword(data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code;
  }

  // 가입 여부 조회
  Future<int> checkJoined(Map data) async {
    Response response = await _userProvider.checkJoined(data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      return codeMsgRespDto.response; // 회원 존재 (1), 가입 가능 (0)
    } else {
      return -1; // 조회 실패 (-1)
    }
  }

  // 아이디 중복확인
  Future<int> checkUsername(String username) async {
    Response response = await _userProvider.checkUsername(username);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      return codeMsgRespDto.response; // 이미 사용중 (1), 사용가능 (0)
    } else {
      return -1; // 조회 실패 (-1)
    }
  }
}
