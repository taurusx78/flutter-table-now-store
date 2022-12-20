import 'package:get/get.dart';

class UpdateMenuReqDto {
  final List<MultipartFile> addedImageFileList; // 추가된 메뉴사진 파일 목록
  final List<String> deletedImageUrlList; // 삭제된 메뉴사진 URL 목록

  UpdateMenuReqDto({
    required this.addedImageFileList,
    required this.deletedImageUrlList,
  });

  Map<String, dynamic> toJson() => {
        'addedImageFileList': addedImageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
