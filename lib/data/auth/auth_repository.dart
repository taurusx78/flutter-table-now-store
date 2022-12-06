import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/data/auth/auth_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  void printData(codeMsgRespDto) {
    print(codeMsgRespDto.code);
    print(codeMsgRespDto.message);
    print(codeMsgRespDto.response);
  }

  // 아임포트 인증 토큰 요청
  Future<String> getToken() async {
    Response response = await _authProvider.getToken();
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    print('----- 아임포트 인증 토큰 요청 -----');
    printData(codeMsgRespDto);

    return codeMsgRespDto.response['access_token'];
  }

  // 본인인증된 사용자 정보 조회
  Future<dynamic> getUserInfo(String imp_uid, String token) async {
    Response response = await _authProvider.getUserInfo(imp_uid, token);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    print('----- 본인인증된 사용자 정보 조회 -----');
    printData(codeMsgRespDto);

    return codeMsgRespDto.response;
  }
}
