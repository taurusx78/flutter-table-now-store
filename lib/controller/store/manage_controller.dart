import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/update_basic_resp_dto.dart';
import 'package:table_now_store/data/store/model/tables.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class ManageController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();

  // 스크롤에 따라 앱바 텍스트 색상 변경
  final ScrollController scrollController = ScrollController();
  final Rx<Color> appBarIconColor = Colors.white.obs; // 앱바 아이콘 색상
  final Rx<Color> appBarTextColor = Colors.transparent.obs; // 앱바 아이콘 색상

  final storeInfo = Rxn<UpdateBasicRespDto>(); // 매장명 & 대표사진
  final today = Rxn<Today>(); // 오늘의 영업시간
  final tables = Rxn<Tables>(); // 테이블 정보

  final RxBool loaded = false.obs; // 조회 완료 여부

  @override
  void onInit() async {
    super.onInit();
    // 스크롤 변경 감지 설정
    scrollController.addListener(() {
      appBarIconColor.value =
          sliverAppBarExpanded() ? Colors.white : Colors.black;
      appBarTextColor.value =
          sliverAppBarExpanded() ? Colors.transparent : Colors.black;
    });
  }

  bool sliverAppBarExpanded() {
    return scrollController.hasClients &&
        scrollController.offset < (190 - kToolbarHeight);
  }

  void initializeAllData(int storeId, String name, String basicImageUrl) async {
    // 매장명 & 대표사진 초기화
    setStoreInfo(name, basicImageUrl);
    // 오늘의 영업시간 조회
    await findToday(storeId);
    // 잔여테이블 수 조회
    await findTables(storeId);
  }

  // 매장명 & 대표사진 설정
  void setStoreInfo(String name, String basicImageUrl) {
    storeInfo.value =
        UpdateBasicRespDto(name: name, basicImageUrl: basicImageUrl);
  }

  // 오늘의 영업시간 조회
  Future<void> findToday(int storeId) async {
    loaded.value = false;
    today.value = await _storeRepository.findToday(storeId);
    loaded.value = true;
  }

  // 잔여테이블 수 조회
  Future<void> findTables(int storeId) async {
    loaded.value = false;
    tables.value = await _storeRepository.findTables(storeId);
    // await changeAvailablePercent(storeId);
    // changeColor();
    loaded.value = true;
  }
}
