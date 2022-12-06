class ChangePwReqDto {
  final String curPassword;
  final String newPassword;

  ChangePwReqDto({
    required this.curPassword,
    required this.newPassword,
  });

  // 데이터를 JSON 형식으로 변경
  Map<String, dynamic> toJson() => {
        'curPassword': curPassword,
        'newPassword': newPassword,
      };
}
