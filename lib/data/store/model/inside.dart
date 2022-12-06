class Inside {
  final int storeId; // 매장 id
  final int allTableCount; // 전체테이블 수
  final List<String> imageUrlList; // 매장내부사진 리스트
  final String insideModified; // 매장내부사진 최종수정일

  Inside({
    required this.storeId,
    required this.allTableCount,
    required this.imageUrlList,
    required this.insideModified,
  });

  // JSON 데이터를 바탕으로 Inside 객체 생성
  Inside.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        allTableCount = json['allTableCount'],
        imageUrlList = List.from(json['imageUrlList']),
        insideModified =
            json['insideModified'].substring(2, 10).replaceAll('-', '.');
}
