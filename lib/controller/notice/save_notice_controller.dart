import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_now_store/controller/dto/notice/save_notice_req_dto.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_repository.dart';

class SaveNoticeController extends GetxController {
  final NoticeRepository _noticeRepository = NoticeRepository();

  final RxBool hasHoliday = false.obs;
  final RxString holidayStartDate = '시작일'.obs;
  final RxString holidayEndDate = '종료일'.obs;

  // 기존 이미지는 String, 새로 추가된 이미지는 XFile 타입
  RxList<dynamic> imageList = [].obs;
  final ImagePicker _picker = ImagePicker();

  var title = TextEditingController();
  var content = TextEditingController();

  final titleFormKey = GlobalKey<FormState>();
  final contentFormKey = GlobalKey<FormState>();

  final RxBool completed = true.obs; // DB 요청 처리 완료 여부

  // 갤러리에서 사진 선택
  Future<void> selectImages() async {
    final List<dynamic>? _selectedImages = await _picker.pickMultiImage();
    if (_selectedImages != null) {
      imageList.addAll(_selectedImages);
    }
  }

  // 알림 등록
  Future<int> save(int storeId) async {
    completed.value = false;

    // XFile 타입을 File 타입으로 변경
    List<File> fileList = imageList.map((image) => File(image.path)).toList();
    // File 타입을 MultipartFile 타입으로 변경
    List<MultipartFile> multipartFileList = fileList
        .map((file) =>
            MultipartFile(file.path, filename: file.path.split('/').last))
        .toList();

    SaveNoticeReqDto dto = SaveNoticeReqDto(
      title: title.text,
      content: content.text,
      holidayStartDate: hasHoliday.value ? holidayStartDate.value : '',
      holidayEndDate: hasHoliday.value ? holidayEndDate.value : '',
      imageFileList: multipartFileList,
    );

    int result = await _noticeRepository.save(storeId, dto.toJson());
    completed.value = true;
    return result;
  }

  // 알림 수정
  Future<int> updateById(int storeId, Notice notice) async {
    completed.value = false;

    List<String> deletedImageUrlList = [
      ...notice.imageUrlList
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

    SaveNoticeReqDto dto = SaveNoticeReqDto(
      title: title.text,
      content: content.text,
      holidayStartDate:
          holidayStartDate.value != '시작일' ? holidayStartDate.value : '',
      holidayEndDate: holidayEndDate.value != '종료일' ? holidayEndDate.value : '',
      imageFileList: multipartFileList,
      deletedImageUrlList: deletedImageUrlList,
    );

    int result =
        await _noticeRepository.updateById(storeId, notice.id, dto.toJson());
    completed.value = true;
    return result;
  }

  // 알림 삭제
  Future<int> deleteById(int storeId, int noticeId) async {
    completed.value = false;
    int result = await _noticeRepository.deleteById(storeId, noticeId);
    completed.value = true;
    return result;
  }

  // 알림 등록 페이지 데이터 초기화
  void initializeSaveNoticePage() {
    hasHoliday.value = false;
    holidayStartDate.value = '시작일';
    holidayEndDate.value = '종료일';
    imageList.value = [];
    title.text = '';
    content.text = '';
  }

  // 알림 수정 페이지 데이터 초기화
  void initializeUpdateNoticePage(Notice notice) {
    // 1. 임시휴무
    if (notice.holidayStartDate == '') {
      hasHoliday.value = false;
    } else {
      hasHoliday.value = true;
      holidayStartDate.value = notice.holidayStartDate.replaceAll('.', '-');
      holidayEndDate.value = notice.holidayEndDate.replaceAll('.', '-');
    }
    // 2. 알림 첨부사진
    if (notice.imageUrlList.isEmpty) {
      imageList.value = [];
    } else {
      // 리스트 깊은 복사 (같은 주소 공간 참조하지 않음)
      imageList.value = [...notice.imageUrlList];
    }
    // 3. 제목 및 내용
    title = TextEditingController(text: notice.title);
    content = TextEditingController(text: notice.content);
  }

  // 임시휴무 여부 변경
  void changeHasHoliday(value) {
    hasHoliday.value = value;
    if (!value) {
      holidayStartDate.value = '시작일';
      holidayEndDate.value = '종료일';
    }
  }

  // 날짜 설정 (type: 시작일 (0), 종료일 (1))
  String selectDate(int type, DateTime dateTime) {
    var date = DateFormat('yyyy-MM-dd').format(dateTime);
    if (type == 0) {
      // 1. 시작일이 종료일보다 늦은 경우
      if (holidayEndDate.value != '종료일' &&
          date.compareTo(holidayEndDate.value) > 0) {
        return '시작일은 종료일보다 늦을 수 없습니다.';
      } else {
        holidayStartDate.value = date.toString();
      }
    } else {
      // 2. 종료일이 시작일보다 앞선 경우
      if (holidayStartDate.value != '시작일' &&
          date.compareTo(holidayStartDate.value) < 0) {
        return '종료일은 시작일보다 앞설 수 없습니다.';
      } else {
        holidayEndDate.value = date.toString();
      }
    }
    return '';
  }

  // 임시휴무 정보 얻기
  String getHolidayInfo() {
    if (!hasHoliday.value) {
      return '임시휴무 설정안함';
    } else {
      if (holidayStartDate.value != '시작일' && holidayEndDate.value != '종료일') {
        return holidayStartDate.value.substring(2).replaceAll('-', '.') +
            ' - ' +
            holidayEndDate.value.substring(2).replaceAll('-', '.') +
            ' 휴무';
      }
      hasHoliday.value = false;
      return '임시휴무 설정안함';
    }
  }
}
