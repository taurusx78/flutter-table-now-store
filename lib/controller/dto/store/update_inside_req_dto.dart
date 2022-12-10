import 'package:get/get.dart';

class UpdateInsideReqDto {
  final int allTableCount; // 전체테이블 수
  final List<MultipartFile> imageFileList; // 추가된 매장내부사진 목록
  final List<String> deletedImageUrlList; // 삭제 요청된 이미지 URL 목록

  UpdateInsideReqDto({
    required this.allTableCount,
    required this.imageFileList,
    required this.deletedImageUrlList,
  });

  Map<String, dynamic> toJson() => {
        'allTableCount': allTableCount,
        'imageFileList': imageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
