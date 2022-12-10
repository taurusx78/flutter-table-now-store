import 'package:get/get.dart';

class UpdateMenuReqDto {
  final List<MultipartFile> imageFileList; // 추가된 메뉴사진 목록
  final List<String> deletedImageUrlList; // 삭제 요청된 이미지 URL 목록

  UpdateMenuReqDto({
    required this.imageFileList,
    required this.deletedImageUrlList,
  });

  Map<String, dynamic> toJson() => {
        'imageFileList': imageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
