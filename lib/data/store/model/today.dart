class Today {
  final int holidayType; // 오늘 휴무 유형 (1 영업일, 2 정기휴무, 3 알림등록 임시휴무, 4 임의변경 임시휴무)
  String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간
  final String state; // 영업상태

  Today({
    required this.holidayType,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
    required this.state,
  }) {
    // 24시 영업 여부
    if (businessHours != '없음' && businessHours != '24시 영업') {
      List<String> businessHoursPart = businessHours.split(' - ');
      if (businessHoursPart[0] == businessHoursPart[1]) {
        businessHours = '24시 영업';
      }
    }
  }

  // JSON 데이터를 Dart 오브젝트로 변경
  static Today fromJson(Map<String, dynamic> json) {
    // 24시 영업 여부
    String businessHours = json['businessHours'];
    if (businessHours != '없음' && businessHours != '24시 영업') {
      List<String> businessHoursPart = json['businessHours'].split(' - ');
      if (businessHoursPart[0] == businessHoursPart[1]) {
        businessHours = '24시 영업';
      }
    }

    return Today(
      holidayType: json['holidayType'],
      businessHours: businessHours,
      breakTime: json['breakTime'],
      lastOrder: json['lastOrder'],
      state: json['state'],
    );
  }
}
