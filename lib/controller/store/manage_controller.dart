import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/update_basic_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/update_inside_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/update_tables_req_dto.dart';
import 'package:table_now_store/data/store/model/tables.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/data/store/store_repository.dart';
import 'package:table_now_store/ui/custom_color.dart';

class ManageController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();

  // 스크롤에 따라 앱바 텍스트 색상 변경
  final ScrollController scrollController = ScrollController();
  final Rx<Color> appBarIconColor = Colors.white.obs; // 앱바 아이콘 색상
  final Rx<Color> appBarTextColor = Colors.transparent.obs; // 앱바 아이콘 색상

  final storeInfo = Rxn<UpdateBasicRespDto>(); // 매장명 & 대표사진
  final today = Rxn<Today>(); // 오늘의 영업시간
  final tables = Rxn<Tables>(); // 테이블 정보

  final Rx<Color> tableColor = const Color(0xFF9E9E9E).obs; // 잔여테이블 수 색상
  final RxDouble availablePercent = 1.0.obs; // 사용가능 테이블 수 퍼센트

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
    if (tables.value != null) {
      await changeAvailablePercent(storeId);
      changeTableColor();
    }
    loaded.value = true;
  }

  // 잔여테이블 수 수정 (type: 감소 (0), 증가 (1), 초기화 (2), 임시중지 (3))
  Future<int> updateTableCount(int storeId, int type, bool paused) async {
    UpdateTablesReqDto data = UpdateTablesReqDto(
      type: type,
      paused: paused,
    );
    // (1) 잔여테이블 0 -> 감소 호출 X
    // (2) 잔여테이블 == 전체테이블 -> 증가, 초기화 호출 X
    if ((type == 0 && tables.value!.tableCount == 0) ||
        ((type == 1 || type == 2) &&
            tables.value!.tableCount == tables.value!.allTableCount)) {
      return 1;
    }
    var result = await _storeRepository.updateTables(storeId, data.toJson());
    if (result.runtimeType == Tables) {
      tables.value = result;
      await changeAvailablePercent(storeId);
      changeTableColor();
      result = 200;
    }
    return result;
  }

  void initializeAllData(int storeId, String name, String basicImageUrl) async {
    // 앱바 색상 초기화
    appBarIconColor.value = Colors.white;
    appBarTextColor.value = Colors.transparent;
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

  // 수정된 오늘의 영업시간 반영
  void changeToday(Today today) {
    this.today.value = today;
  }

  // 사용가능 테이블 수 퍼센트 변경
  Future<void> changeAvailablePercent(int storeId) async {
    // 잔여테이블 수 > 전체테이블 수 오류 제거
    if (tables.value!.tableCount > tables.value!.allTableCount) {
      await updateTableCount(storeId, 2, false);
    }
    availablePercent.value =
        tables.value!.tableCount / tables.value!.allTableCount;
  }

  // 잔여테이블 수 색상 변경
  void changeTableColor() {
    Color color = const Color(0xFF9E9E9E);
    if (today.value!.state == '영업중') {
      if (!tables.value!.paused) {
        color = tables.value!.tableCount >= 4
            ? green
            : tables.value!.tableCount >= 2
                ? yellow
                : red;
      }
    }
    tableColor.value = color;
  }

  // 수정된 전체테이블 수 반영
  void changeTables(UpdateInsideRespDto dto) {
    tables.value = Tables(
      allTableCount: dto.allTableCount,
      tableCount: dto.tableCount,
      paused: tables.value!.paused,
      modifiedDate: tables.value!.modifiedDate,
    );
    availablePercent.value = 1;
  }
}
