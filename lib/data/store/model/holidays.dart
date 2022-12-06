class Holidays {
  final int storeId; // 매장 id
  final String holidays; // 정기휴무 목록
  final String modifiedDate; // 최종수정일

  Holidays({
    required this.storeId,
    required this.holidays,
    required this.modifiedDate,
  });

  // JSON 데이터를 바탕으로 Holidays 객체 생성
  Holidays.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        holidays = json['holidays'],
        modifiedDate =
            json['modifiedDate'].substring(2, 10).replaceAll('-', '.');
}
