class FindIdReqDto {
  final String method; // 인증방식 (이메일 또는 휴대폰번호)
  final String data; // 이메일 또는 휴대폰번호 정보
  final String authNumber; // 인증번호

  FindIdReqDto({
    required this.method,
    required this.data,
    required this.authNumber,
  });

  Map<String, String> toJson() => {
        'method': method,
        'data': data,
        'authNumber': authNumber,
      };
}
