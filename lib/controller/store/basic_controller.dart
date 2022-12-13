import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/dto/store/update_basic_req_dto.dart';
import 'package:table_now_store/data/store/model/basic.dart';
import 'package:table_now_store/data/store/store_repository.dart';
import 'package:validators/validators.dart';

import 'location_controller.dart';

class BasicController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  Basic? basic;

  final name = TextEditingController();
  final category = TextEditingController();
  final RxString rxCategory = ''.obs;
  final RxString areaCode = '010'.obs;
  final phone = TextEditingController();
  final address = TextEditingController(); // 도로명주소
  final detailAddress = TextEditingController(); // 상세주소
  final RxString jibunAddress = ''.obs; // 지번주소
  final RxDouble latitude = 0.0.obs; // 위도
  final RxDouble longitude = 0.0.obs; // 경도
  final description = TextEditingController();
  final website = TextEditingController();

  final phoneFocusNode = FocusNode(); // 전화번호 FocusNode
  final detailAddressFocusNode = FocusNode(); // 상세주소 FocusNode

  // 업로드된 대표사진 목록 (XFile 타입 ) or 조회한 대표사진 목록 (String 타입)
  RxList<dynamic> imageList = [].obs;
  final ImagePicker _picker = ImagePicker();

  final RxBool activated = false.obs; // 조회 버튼 활성화 여부
  final RxBool loaded = true.obs; // 조회 완료 여부

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    name.addListener(checkButtonActivated);
    category.addListener(checkButtonActivated);
    phone.addListener(checkButtonActivated);
    address.addListener(checkButtonActivated);
    detailAddress.addListener(checkButtonActivated);
  }

  // 갤러리에서 사진 선택
  Future<void> selectImages() async {
    final List<dynamic>? _selectedImages = await _picker.pickMultiImage();
    if (_selectedImages != null) {
      imageList.addAll(_selectedImages);
    }
  }

  // 기본정보 조회 및 초기화
  Future<void> findBasic(int storeId) async {
    loaded.value = false;
    basic = await _storeRepository.findBasic(storeId);
    // 조회 성공
    if (basic != null) {
      name.text = basic!.name;
      rxCategory.value = basic!.category;
      // '-'를 기준으로 전화번호 나누기
      List<String> phoneParts = basic!.phone.split('-');
      areaCode.value = phoneParts[0];
      phone.text = '${phoneParts[1]}${phoneParts[2]}';
      address.text = basic!.address;
      detailAddress.text = basic!.detailAddress;
      jibunAddress.value = basic!.jibunAddress;
      latitude.value = basic!.latitude;
      longitude.value = basic!.longitude;
      // 리스트 깊은 복사 (같은 주소 공간 참조하지 않음)
      imageList.value = [...basic!.imageUrlList];
      description.text = basic!.description;
      website.text = basic!.website;
      // 네이버지도 이미지 불러오기
      await Get.put(LocationController())
          .getLocationMap(longitude.value, latitude.value);
    }
    loaded.value = true;
  }

  // 기본정보 수정
  Future<dynamic> updateBasic(int storeId) async {
    List<String> deletedImageUrlList = [
      ...basic!.imageUrlList
    ]; // 삭제된 이미지 Url 리스트 초기화
    List<File> fileList = []; // 추가된 이미지 파일 리스트
    for (var item in imageList) {
      if (item.runtimeType == String) {
        deletedImageUrlList.remove(item);
      } else {
        fileList.add(File(item.path));
      }
    }
    // File 타입을 MultipartFile 타입으로 변경
    List<MultipartFile> multipartFileList = fileToMultipartFile(fileList);

    UpdateBasicReqDto dto = UpdateBasicReqDto(
      phone:
          '${areaCode.value}-${phone.text.replaceAllMapped(RegExp(r'(\d{3,4})(\d{4})'), (m) => '${m[1]}-${m[2]}')}',
      address: address.text,
      detailAddress: detailAddress.text,
      jibunAddress: jibunAddress.value,
      latitude: latitude.value,
      longitude: longitude.value,
      description: description.text,
      website: website.text,
      imageFileList: multipartFileList,
      deletedImageUrlList: deletedImageUrlList,
    );
    dynamic result = await _storeRepository.updateBasic(storeId, dto.toJson());
    return result;
  }

  // 선택된 카테고리 항목 변경
  void changeCategory(String value) {
    rxCategory.value = value;
    category.text = value;
  }

  // 선택된 지역번호 변경
  void changeAreaCode(String value) {
    areaCode.value = value.split(' ')[0];
  }

  // 조회 버튼 활성화 여부 확인
  void checkButtonActivated() {
    if (name.text.isNotEmpty && // 매장명 공백 아님
        category.text.isNotEmpty && // 카테고리 공백 아님
        isNumeric(phone.text) && // 전화번호 7~8자 숫자
        phone.text.length >= 7 &&
        address.text.isNotEmpty && // 주소 공백 아님
        detailAddress.text.isNotEmpty) {
      activated.value = true;
    } else {
      activated.value = false;
    }
  }

  // 등록여부조회 페이지에서 입력된 정보를 바탕으로 SaveStoreReqDto 객체 생성
  SaveStoreReqDto makeSaveStoreReqDto() {
    SaveStoreReqDto dto = SaveStoreReqDto();
    dto.setBasicInfo1(
        name.text,
        category.text,
        areaCode.value +
            '-' +
            phone.text.replaceAllMapped(
                RegExp(r'(\d{3,4})(\d{4})'), (m) => '${m[1]}-${m[2]}'),
        address.text,
        detailAddress.text,
        jibunAddress.value,
        latitude.value,
        longitude.value);
    return dto;
  }

  // 기본정보 등록 페이지에서 입력된 정보 SaveStoreReqDto 객체에 추가
  SaveStoreReqDto setBasicInfo(SaveStoreReqDto dto) {
    // 이미지 타입 변경
    List<File> fileList = imageList.map((image) => File(image.path)).toList();
    List<MultipartFile> multipartFileList = fileToMultipartFile(fileList);
    dto.setBasicInfo2(multipartFileList, description.text, website.text);
    return dto;
  }

  // File 타입을 MultipartFile 타입으로 변경
  List<MultipartFile> fileToMultipartFile(List<File> fileList) {
    List<MultipartFile> multipartFileList = fileList
        .map((file) =>
            MultipartFile(file.path, filename: file.path.split('/').last))
        .toList();
    return multipartFileList;
  }
}
