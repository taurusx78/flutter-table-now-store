// 나의 매장 전체조회 시 응답 받은 데이터를 전달하는 DTO

class MyStoreRespDto {
  final int id; // 매장 id
  final String name; // 매장명
  final String address; // 도로명주소
  final String detailAddress; // 상세주소
  final String phone; // 전화
  final String basicImageUrl; // 대표사진 1개
  final int holidayType; // 오늘 휴무 유형 (1 영업일, 2 정기휴무, 3 알림등록 임시휴무, 4 임의변경 임시휴무)
  final String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간
  final String state; // 영업상태

  MyStoreRespDto({
    required this.id,
    required this.name,
    required this.address,
    required this.detailAddress,
    required this.phone,
    required this.basicImageUrl,
    required this.holidayType,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
    required this.state,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  static MyStoreRespDto fromJson(Map<String, dynamic> json) {
    // 24시 영업 여부
    String businessHours = json['businessHours'];
    if (businessHours != '없음') {
      List<String> businessHoursPart = json['businessHours'].split(' - ');
      if (businessHoursPart[0] == businessHoursPart[1]) {
        businessHours = '24시 영업';
      }
    }

    return MyStoreRespDto(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      detailAddress: json['detailAddress'],
      phone: json['phone'],
      basicImageUrl: json['basicImageUrl'],
      holidayType: json['holidayType'],
      businessHours: businessHours,
      breakTime: json['breakTime'],
      lastOrder: json['lastOrder'],
      state: json['state'],
    );
  }
}
