class User {
  final String username; // 아이디
  final String name; // 이름
  String phone; // 휴대폰번호
  String email; // 이메일

  User({
    required this.username,
    required this.name,
    required this.phone,
    required this.email,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        phone = json['phone'].replaceAllMapped(
            RegExp(r'(\d{3})(\d{3,4})(\d{4})'),
            (m) => '${m[1]}-${m[2]}-${m[3]}'),
        email = json['email'];

  // 데이터를 JSON 형식으로 변경
  Map<String, dynamic> toJson() => {
        'username': username,
        'name': name,
        'phone': phone,
        'email': email,
      };
}
