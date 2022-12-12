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

  final List<MultipartFile> imageFileList; // 대표사진 리스트
  final List<String> deletedImageUrlList; // 삭제 요청 이미지 URL 리스트

  UpdateBasicReqDto({
    required this.phone,
    required this.address,
    required this.detailAddress,
    required this.jibunAddress,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.website,
    required this.imageFileList,
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
        'imageFileList': imageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
