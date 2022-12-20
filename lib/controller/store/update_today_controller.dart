import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/update_today_req_dto.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class UpdateTodayController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();

  final List<RxBool> switchState = [
    false.obs, // 휴무 여부 (0)
    false.obs, // 24시영업 여부 (1)
    false.obs, // 휴게시간 유무 (2)
    false.obs, // 주문마감시간 유무 (3)
  ];

  final List<RxString> timeList = [
    '10:00'.obs, // 오픈시간 (0)
    '22:00'.obs, // 마감시간 (1)
    '15:00'.obs, // 휴게 시작시간 (2)
    '17:00'.obs, // 휴게 종료시간 (3)
    '22:00'.obs, // 주문 마감시간 (4)
  ];

  // 오늘의 영업시간 수정
  Future<dynamic> updateToday(int storeId) async {
    UpdateTodayReqDto dto;
    if (!switchState[0].value) {
      // 1. 영업일인 경우
      dto = UpdateTodayReqDto(
        holiday: false,
        businessHours: timeList[0].value + ' - ' + timeList[1].value,
        breakTime: !switchState[2].value
            ? '없음'
            : timeList[2].value + ' - ' + timeList[3].value,
        lastOrder: !switchState[3].value ? '없음' : timeList[4].value,
      );
    } else {
      // 2. 휴무일인 경우
      dto = UpdateTodayReqDto(
        holiday: true,
        businessHours: '없음',
        breakTime: '없음',
        lastOrder: '없음',
      );
    }
    return await _storeRepository.updateToday(storeId, dto.toJson());
  }

  // 오늘의 영업시간 데이터 초기화
  void initializeTodayData(Today today) {
    switchState[0].value = today.holidayType != 1;
    // 영업일인 경우
    if (!switchState[0].value) {
      // 1. 영업시간
      timeList[0].value = today.businessHours.split(' - ')[0];
      timeList[1].value = today.businessHours.split(' - ')[1];
      switchState[1].value = (timeList[0].value == timeList[1].value);
      // 2. 휴게시간
      switchState[2].value = today.breakTime == '없음' ? false : true;
      if (switchState[2].value) {
        timeList[2].value = today.breakTime.split(' - ')[0];
        timeList[3].value = today.breakTime.split(' - ')[1];
      }
      // 3. 주문마감시간
      switchState[3].value = today.lastOrder == '없음' ? false : true;
      if (switchState[3].value) {
        timeList[4].value = today.lastOrder;
      } else {
        timeList[4].value = timeList[1].value;
      }
    }
  }

  // Switch 버튼 상태 변경
  void changeSwitchState(int type, bool value, Today today) {
    switchState[type].value = value;
    // 24시 운영 여부
    if (type == 1) {
      if (switchState[1].value) {
        timeList[0].value = '00:00';
        timeList[1].value = '00:00';
      } else {
        timeList[0].value = today.businessHours.split(' - ')[0];
        timeList[1].value = today.businessHours.split(' - ')[1];
      }
    }
  }

  // 설정된 시간 변경
  void changeTime(int type, time) {
    String changedTime =
        '${time.hour}'.padLeft(2, '0') + ':' + '${time.minute}'.padLeft(2, '0');
    timeList[type].value = changedTime;
    // 24시 영업 여부 확인
    if (type == 0 || type == 1) {
      check24Hours();
    }
  }

  // 24시 영업 여부 확인
  void check24Hours() {
    switchState[1].value =
        timeList[0].value == '00:00' && timeList[1].value == '00:00';
  }
}
