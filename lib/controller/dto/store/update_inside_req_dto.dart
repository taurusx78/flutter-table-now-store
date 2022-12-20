import 'package:get/get.dart';

class UpdateInsideReqDto {
  final int allTableCount; // 전체테이블 수
  final List<MultipartFile> addedImageFileList; // 추가된 매장내부사진 파일 목록
  final List<String> deletedImageUrlList; // 삭제된 매장내부사진 URL 목록

  UpdateInsideReqDto({
    required this.allTableCount,
    required this.addedImageFileList,
    required this.deletedImageUrlList,
  });

  Map<String, dynamic> toJson() => {
        'allTableCount': allTableCount,
        'addedImageFileList': addedImageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
