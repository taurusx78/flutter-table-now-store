// 나의 매장 1개 조회 시 응답 받은 데이터를 전달하는 DTO

class OneMyStoreRespDto {
  final int id; // 매장 id
  final String name; // 매장명
  final String basicImageUrl; // 대표사진 1개
  final int holidayType; // 오늘 휴무 유형 (1 영업일, 2 정기휴무, 3 알림등록 임시휴무, 4 임의변경 임시휴무)
  final String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간
  final String state; // 영업상태
  final int allTableCount; // 전체테이블 수
  final int tableCount; // 잔여테이블 수
  final bool paused; // 테이블 수 제공 임시중지 여부
  final String tableModified; // 테이블 수 최종수정일

  OneMyStoreRespDto({
    required this.id,
    required this.name,
    required this.basicImageUrl,
    required this.holidayType,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
    required this.state,
    required this.allTableCount,
    required this.tableCount,
    required this.paused,
    required this.tableModified,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  OneMyStoreRespDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        basicImageUrl = json['basicImageUrl'],
        holidayType = json['holidayType'],
        businessHours = json['businessHours'],
        breakTime = json['breakTime'],
        lastOrder = json['lastOrder'],
        state = json['state'],
        allTableCount = json['allTableCount'],
        tableCount = json['tableCount'],
        paused = json['paused'],
        tableModified = json['tableModified'];
}
