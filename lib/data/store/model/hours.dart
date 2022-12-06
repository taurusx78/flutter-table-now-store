class Hours {
  final int storeId; // 매장 id
  final List<String> openTimeList; // 오픈시간 목록
  final List<String> closeTimeList; // 마감시간 목록
  final List<bool> run24HoursList; // 24시운영 여부 목록
  final List<bool> hasBreakTimeList; // 휴게시간 유무 목록
  final List<String> startBreakTimeList; // 휴게시간 시작 목록
  final List<String> endBreakTimeList; // 휴게시간 종료 목록
  final List<bool> hasLastOrderList; // 주문마감시간 유무 목록
  final List<String> lastOrderList; // 주문마감시간 목록
  final String? modifiedDate; // 최종수정일

  Hours({
    required this.storeId,
    required this.openTimeList,
    required this.closeTimeList,
    required this.run24HoursList,
    required this.hasBreakTimeList,
    required this.startBreakTimeList,
    required this.endBreakTimeList,
    required this.hasLastOrderList,
    required this.lastOrderList,
    required this.modifiedDate,
  });

  // JSON 데이터를 바탕으로 Hours 객체 생성
  Hours.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        openTimeList = List.from(json['openTimeList']),
        closeTimeList = List.from(json['closeTimeList']),
        run24HoursList = List.from(json['run24HoursList']),
        hasBreakTimeList = List.from(json['hasBreakTimeList']),
        startBreakTimeList = List.from(json['startBreakTimeList']),
        endBreakTimeList = List.from(json['endBreakTimeList']),
        hasLastOrderList = List.from(json['hasLastOrderList']),
        lastOrderList = List.from(json['lastOrderList']),
        modifiedDate =
            json['modifiedDate'].substring(2, 10).replaceAll('-', '.');
}
