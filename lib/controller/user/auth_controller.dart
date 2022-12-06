import 'package:get/get.dart';
import 'package:table_now_store/data/auth/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // 아임포트 인증 토큰 요청
  Future<String> getToken() async {
    return await _authRepository.getToken();
  }

  // 본인인증된 사용자 정보 조회
  Future<dynamic> getUserInfo(String imp_uid, String token) async {
    return await _authRepository.getUserInfo(imp_uid, token);
  }
}
