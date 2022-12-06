class JoinReqDto {
  final String username; // 아이디
  final String password; // 비밀번호
  final String name; // 이름
  final String phone; // 휴대폰번호
  final String uniqueKey; // 개인고유식별자
  final String email; // 이메일

  JoinReqDto({
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.uniqueKey,
    required this.email,
  });

  // 데이터를 JSON 형식으로 변경
  Map<String, String> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'phone': phone,
        'uniqueKey': uniqueKey,
        'email': email,
      };
}
