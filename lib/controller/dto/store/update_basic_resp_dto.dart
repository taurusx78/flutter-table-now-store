class UpdateBasicRespDto {
  final String name; // 매장명
  final String basicImageUrl; // 대표사진 1개

  UpdateBasicRespDto({
    required this.name,
    required this.basicImageUrl,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  UpdateBasicRespDto.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        basicImageUrl = json['basicImageUrl'];
}
