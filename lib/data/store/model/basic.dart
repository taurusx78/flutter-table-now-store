class Basic {
  final int storeId; // 매장 id
  final String name; // 매장명
  final String category; // 카테고리
  final String phone; // 전화번호
  final String address; // 도로명주소
  final String jibunAddress; // 지번주소
  final double latitude; // 위도
  final double longitude; // 경도
  final String description; // 매장 소개
  final String website; // 웹사이트
  final List<String> imageUrlList; // 대표사진 리스트
  final String modifiedDate; // 최종수정일

  Basic({
    required this.storeId,
    required this.name,
    required this.category,
    required this.phone,
    required this.address,
    required this.jibunAddress,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.website,
    required this.imageUrlList,
    required this.modifiedDate,
  });

  // JSON 데이터를 바탕으로 Basic 객체 생성
  Basic.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        name = json['name'],
        category = json['category'],
        phone = json['phone'],
        address = json['address'],
        jibunAddress = json['jibunAddress'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        description = json['description'],
        website = json['website'],
        imageUrlList = List.from(json['imageUrlList']),
        modifiedDate =
            json['modifiedDate'].substring(2, 10).replaceAll('-', '.');
}
