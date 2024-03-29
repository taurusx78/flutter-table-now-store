import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/dto/store/update_hours_req_dto.dart';
import 'package:table_now_store/data/store/model/hours.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class HoursController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  Hours? hours;
  final List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

  // 24시영업 여부 (0), 휴게시간 유무 (1), 주문마감시간 유무 (2)
  final RxList<RxList<bool>> switchState = [
    [false, false, false, false, false, false, false].obs,
    [false, false, false, false, false, false, false].obs,
    [false, false, false, false, false, false, false].obs,
  ].obs;

  // 오픈시간 (0), 마감시간 (1), 휴게시작시간 (2), 휴게종료시간 (3), 주문마감시간 (4)
  RxList<RxList<String>> timeList = [
    ['10:00', '10:00', '10:00', '10:00', '10:00', '10:00', '10:00'].obs,
    ['22:00', '22:00', '22:00', '22:00', '22:00', '22:00', '22:00'].obs,
    ['15:00', '15:00', '15:00', '15:00', '15:00', '15:00', '15:00'].obs,
    ['17:00', '17:00', '17:00', '17:00', '17:00', '17:00', '17:00'].obs,
    ['22:00', '22:00', '22:00', '22:00', '22:00', '22:00', '22:00'].obs,
  ].obs;

  final RxBool loaded = true.obs; // 조회 완료 여부

  // 영업시간 조회 및 데이터 초기화
  Future<void> findHours(int storeId) async {
    loaded.value = false;
    hours = await _storeRepository.findHours(storeId);
    if (hours != null) {
      initializeHours(hours);
    }
    loaded.value = true;
  }

  // 영업시간 수정
  Future<dynamic> updateHours(int storeId) async {
    UpdateHoursReqDto dto = UpdateHoursReqDto(
      openTimeList: timeList[0],
      closeTimeList: timeList[1],
      hasBreakTimeList: switchState[1],
      startBreakTimeList: timeList[2],
      endBreakTimeList: timeList[3],
      hasLastOrderList: switchState[2],
      lastOrderList: timeList[4],
    );
    return await _storeRepository.updateHours(storeId, dto.toJson());
  }

  // 영업시간 전체 초기화
  void initializeHours(Hours? hours) {
    if (hours != null) {
      // 1. 영업시간
      timeList[0].value = hours.openTimeList;
      timeList[1].value = hours.closeTimeList;
      switchState[0].value = hours.run24HoursList;
      // 2. 휴게시간
      switchState[1].value = hours.hasBreakTimeList;
      timeList[2].value = hours.startBreakTimeList;
      timeList[3].value = hours.endBreakTimeList;
      // 3. 주문마감시간
      switchState[2].value = hours.hasLastOrderList;
      timeList[4].value = hours.lastOrderList;
    } else {
      switchState.value = [
        [false, false, false, false, false, false, false].obs,
        [false, false, false, false, false, false, false].obs,
        [false, false, false, false, false, false, false].obs,
      ];
      timeList.value = [
        ['10:00', '10:00', '10:00', '10:00', '10:00', '10:00', '10:00'].obs,
        ['22:00', '22:00', '22:00', '22:00', '22:00', '22:00', '22:00'].obs,
        ['15:00', '15:00', '15:00', '15:00', '15:00', '15:00', '15:00'].obs,
        ['17:00', '17:00', '17:00', '17:00', '17:00', '17:00', '17:00'].obs,
        ['22:00', '22:00', '22:00', '22:00', '22:00', '22:00', '22:00'].obs,
      ];
    }
  }

  // 설정된 시간 변경
  void changeTime(int type, int day, DateTime time) {
    timeList[type][day] =
        '${time.hour}'.padLeft(2, '0') + ':' + '${time.minute}'.padLeft(2, '0');
  }

  // Switch 버튼 상태 변경
  void changeSwitchState(int type, int day) {
    switchState[type][day] = !switchState[type][day];
    if (type == 0) {
      // 1. 24시 영업 여부
      if (switchState[type][day]) {
        timeList[0][day] = '00:00';
        timeList[1][day] = '00:00';
      } else {
        timeList[0][day] = '10:00';
        timeList[1][day] = '22:00';
      }
    } else if (type == 1) {
      // 2. 휴게시간 유무
      if (switchState[type][day]) {
        timeList[2][day] = '15:00';
        timeList[3][day] = '17:00';
      }
    } else {
      // 3. 주문마감시간 유무
      if (switchState[type][day]) {
        // 마감시간 값으로 초기화
        timeList[4][day] = timeList[1][day];
      }
    }
  }

  // 영업시간 등록 페이지에서 입력된 정보 SaveStoreReqDto 객체에 추가
  SaveStoreReqDto setHoursInfo(SaveStoreReqDto dto) {
    List<List<String>> hours = hoursDataProcessing();
    dto.setHoursInfo(hours);
    return dto;
  }

  // 영업시간 데이터 가공
  List<List<String>> hoursDataProcessing() {
    List<String> businessHoursList = [];
    List<String> breakTimeList = [];
    List<String> lastOrderList = [];

    for (int d = 0; d < 7; d++) {
      // 1. 영업시간
      businessHoursList.add(timeList[0][d] + ' - ' + timeList[1][d]);
      // 2. 휴게시간
      if (switchState[1][d]) {
        breakTimeList.add(timeList[2][d] + ' - ' + timeList[3][d]);
      } else {
        breakTimeList.add('없음');
      }
      // 3. 주문마감시간
      if (switchState[2][d]) {
        lastOrderList.add(timeList[4][d]);
      } else {
        lastOrderList.add('없음');
      }
    }
    return [businessHoursList, breakTimeList, lastOrderList];
  }
}
