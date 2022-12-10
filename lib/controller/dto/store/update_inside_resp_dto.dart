class UpdateInsideRespDto {
  final int allTableCount; // 전체테이블 수
  final int tableCount; // 잔여테이블 수

  UpdateInsideRespDto({
    required this.allTableCount,
    required this.tableCount,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  UpdateInsideRespDto.fromJson(Map<String, dynamic> json)
      : allTableCount = json['allTableCount'],
        tableCount = json['tableCount'];
}
