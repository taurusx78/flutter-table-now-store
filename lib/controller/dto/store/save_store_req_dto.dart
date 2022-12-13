import 'package:get/get.dart';

// 매장 등록 요청 시 입력된 데이터를 전달하는 DTO

class SaveStoreReqDto {
  String name = ''; // 매장명
  String category = ''; // 카테고리
  String phone = ''; // 전화
  String address = ''; // 도로명주소
  String detailAddress = ''; // 상세주소
  String jibunAddress = ''; // 지번주소
  double latitude = 0.0; // 위도
  double longitude = 0.0; // 경도
  String description = ''; // 소개
  String website = ''; // 웹사이트
  int allTableCount = 0; // 전체테이블 수

  List<MultipartFile> basicImageFileList = <MultipartFile>[]; // 대표사진 파일 리스트
  List<MultipartFile> insideImageFileList = <MultipartFile>[]; // 매장내부사진 파일 리스트
  List<MultipartFile> menuImageFileList = <MultipartFile>[]; // 메뉴사진 파일 리스트

  String holidays = ''; // 정기휴무 목록
  List<String> businessHoursList = <String>[]; // 영업시간 목록
  List<String> breakTimeList = <String>[]; // 휴게시간 목록
  List<String> lastOrderList = <String>[]; // 주문마감시간 목록

  // 기본정보 1 설정
  void setBasicInfo1(
      String name,
      String category,
      String phone,
      String address,
      String detailAddress,
      String jibunAddress,
      double latitude,
      double longitude) {
    this.name = name;
    this.category = category;
    this.phone = phone;
    this.address = address;
    this.detailAddress = detailAddress;
    this.jibunAddress = jibunAddress;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  // 기본정보 2 설정
  void setBasicInfo2(List<MultipartFile> basicImageFileList, String description,
      String website) {
    this.basicImageFileList = basicImageFileList;
    this.description = description;
    this.website = website;
  }

  // 매장내부정보 설정
  void setInsideInfo(
      int allTableCount, List<MultipartFile> insideImageFileList) {
    this.allTableCount = allTableCount;
    this.insideImageFileList = insideImageFileList;
  }

  // 메뉴정보 설정
  void setMenuInfo(List<MultipartFile> menuImageFileList) {
    this.menuImageFileList = menuImageFileList;
  }

  // 정기휴무 설정
  void setHolidaysInfo(String holidays) {
    this.holidays = holidays;
  }

  // 영업시간 설정
  void setHoursInfo(List<List<String>> hours) {
    businessHoursList = hours[0];
    breakTimeList = hours[1];
    lastOrderList = hours[2];
  }

  // 데이터를 JSON 형식으로 변경
  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'phone': phone,
        'address': address,
        'detailAddress': detailAddress,
        'jibunAddress': jibunAddress,
        'latitude': latitude,
        'longitude': longitude,
        'basicImageFileList': basicImageFileList,
        'description': description,
        'website': website,
        'allTableCount': allTableCount,
        'insideImageFileList': insideImageFileList,
        'menuImageFileList': menuImageFileList,
        'holidays': holidays,
        'businessHoursList': businessHoursList,
        'breakTimeList': breakTimeList,
        'lastOrderList': lastOrderList,
      };
}
