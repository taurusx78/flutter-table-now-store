class ResetPwReqDto {
  final String username; // 아이디
  final String newPassword; // 새 비밀번호
  final String authNumber; // 인증번호

  ResetPwReqDto({
    required this.username,
    required this.newPassword,
    required this.authNumber,
  });

  // 데이터를 JSON 형식으로 변경
  Map<String, dynamic> toJson() => {
        'username': username,
        'newPassword': newPassword,
        'authNumber': authNumber,
      };
}
