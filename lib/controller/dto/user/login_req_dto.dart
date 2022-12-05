class LoginReqDto {
  final String username;
  final String password;

  LoginReqDto(this.username, this.password);

  // 데이터를 JSON 형식으로 변경
  Map<String, String> toJson() => {
        'username': username,
        'password': password,
      };
}
