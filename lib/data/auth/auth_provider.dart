import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  // 아임포트 REST API 키 & 시크릿
  Map<String, String> data = {
    'imp_key': '2041700442816406',
    'imp_secret':
        '1K3ogpTozxTr0FzyU0x1SlSQ04hBsyCrTiyEldhpL8VxqsJP2nnusOu8jDUAvw4sbOHrY8ztPCx9qJAM',
  };

  // 아임포트 인증 토큰 요청
  Future<Response> getToken() => post(
        'https://api.iamport.kr/users/getToken',
        data,
        contentType: 'application/json',
      );

  // 인증된 사용자 정보 조회
  Future<Response> getUserInfo(String imp_uid, String token) =>
      get('https://api.iamport.kr/certifications/$imp_uid',
          headers: {'Authorization': token});
}
