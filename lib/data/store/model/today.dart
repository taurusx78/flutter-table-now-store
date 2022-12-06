class Today {
  final int holidayType; // 오늘 휴무 유형 (1 영업일, 2 정기휴무, 3 알림등록 임시휴무, 4 임의변경 임시휴무)
  final String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간
  final String state; // 영업상태

  Today({
    required this.holidayType,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
    required this.state,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  Today.fromJson(Map<String, dynamic> json)
      : holidayType = json['holidayType'],
        businessHours = json['businessHours'],
        breakTime = json['breakTime'],
        lastOrder = json['lastOrder'],
        state = json['state'];
}
