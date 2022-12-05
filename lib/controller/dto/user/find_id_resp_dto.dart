class FindIdRespDto {
  final String username; // 아이디
  final String createdDate; // 가입일

  FindIdRespDto({
    required this.username,
    required this.createdDate,
  });

  FindIdRespDto.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        createdDate = json['createdDate'].substring(2, 10).replaceAll('-', '.');
}
