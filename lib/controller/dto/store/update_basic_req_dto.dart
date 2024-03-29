import 'package:get/get.dart';

class UpdateBasicReqDto {
  final String phone; // 전화번호
  final String address; // 도로명주소
  final String detailAddress; // 상세주소
  final String jibunAddress; // 지번주소
  final double latitude; // 위도
  final double longitude; // 경도
  final String description; // 상세설명
  final String website; // 웹사이트

  final List<MultipartFile> addedImageFileList; // 추가된 대표사진 파일 리스트
  final List<String> deletedImageUrlList; // 삭제된 대표사진 URL 리스트

  UpdateBasicReqDto({
    required this.phone,
    required this.address,
    required this.detailAddress,
    required this.jibunAddress,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.website,
    required this.addedImageFileList,
    required this.deletedImageUrlList,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'address': address,
        'detailAddress': detailAddress,
        'jibunAddress': jibunAddress,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'website': website,
        'addedImageFileList': addedImageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
