class Tables {
  final int allTableCount; // 전체테이블 수
  final int tableCount; // 잔여테이블 수
  final bool paused;
  final String modifiedDate;

  Tables({
    required this.allTableCount,
    required this.tableCount,
    required this.paused,
    required this.modifiedDate,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  Tables.fromJson(Map<String, dynamic> json)
      : allTableCount = json['allTableCount'],
        tableCount = json['tableCount'],
        paused = json['paused'],
        modifiedDate = json['modifiedDate'];
}
