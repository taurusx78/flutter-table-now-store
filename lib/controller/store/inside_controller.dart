import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_now_store/controller/dto/store/update_inside_req_dto.dart';
import 'package:table_now_store/controller/dto/store/update_inside_resp_dto.dart';
import 'package:table_now_store/data/store/model/inside.dart';
import 'package:table_now_store/data/store/store_repository.dart';
import 'package:validators/validators.dart';

class InsideController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  Inside? inside;
  final allTableCount = TextEditingController(text: '0');

  // 업로드된 내부사진 목록 (XFile 타입 ) or 조회한 내부사진 목록 (String 타입)
  RxList<dynamic> imageList = [].obs;
  final ImagePicker _picker = ImagePicker();

  final RxBool loaded = true.obs; // 조회 완료 여부

  // 갤러리에서 사진 선택
  Future<void> selectImages() async {
    final List<dynamic>? _selectedImages = await _picker.pickMultiImage();
    if (_selectedImages != null) {
      imageList.addAll(_selectedImages);
    }
  }

  // 매장내부정보 조회 및 초기화
  Future<void> findInside(int storeId) async {
    loaded.value = false;
    inside = await _storeRepository.findInside(storeId);
    // 조회 성공
    if (inside != null) {
      allTableCount.text = inside!.allTableCount.toString();
      // 리스트 깊은 복사 (같은 주소 공간 참조하지 않음)
      imageList.value = [...inside!.imageUrlList];
    }
    loaded.value = true;
  }

  // 매장내부정보 수정
  Future<dynamic> updateInside(int storeId) async {
    List<String> deletedImageUrlList = [
      ...inside!.imageUrlList
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
    List<MultipartFile> multipartFileList = fileList
        .map((file) =>
            MultipartFile(file.path, filename: file.path.split('/').last))
        .toList();

    UpdateInsideReqDto dto = UpdateInsideReqDto(
        allTableCount: int.parse(allTableCount.text),
        imageFileList: multipartFileList,
        deletedImageUrlList: deletedImageUrlList);
    UpdateInsideRespDto updateInsideResp =
        await _storeRepository.updateInside(storeId, dto.toJson());
    return updateInsideResp;
  }

  // 전체테이블 수 변경
  int changeAllTableCount(bool isSub) {
    // 숫자 외의 다른 문자가 입력된 경우
    if (!isNumeric(allTableCount.text.trim())) {
      allTableCount.text = '0';
      return -1;
    }

    int count = int.parse(allTableCount.text.trim());
    if (isSub) {
      // 1. 감소
      if (count > 0) {
        allTableCount.text = (count - 1).toString();
      }
    } else {
      // 2. 증가
      if (count < 500) {
        allTableCount.text = (count + 1).toString();
      }
    }
    return 1;
  }

  // 전체테이블 수 0~500 범위의 숫자 여부
  bool validateAllTableCount() {
    String count = allTableCount.text.trim();
    if (isNumeric(count) && int.parse(count) >= 0 && int.parse(count) <= 500) {
      return true;
    } else {
      allTableCount.text = '0';
      return false;
    }
  }
}
