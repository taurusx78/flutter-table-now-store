class Menu {
  final int storeId; // 매장 id
  final List<String> imageUrlList; // 메뉴사진 목록
  final String modifiedDate; // 최종수정일

  Menu({
    required this.storeId,
    required this.imageUrlList,
    required this.modifiedDate,
  });

  // JSON 데이터를 바탕으로 Menu 객체 생성
  Menu.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        imageUrlList = List.from(json['imageUrlList']),
        modifiedDate =
            json['modifiedDate'].substring(2, 10).replaceAll('-', '.');
}
