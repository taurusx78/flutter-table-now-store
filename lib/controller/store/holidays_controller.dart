import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/data/store/model/holidays.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class HolidaysController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  Holidays? holidays;
  final List<String> weeks = ['매주', '첫째주', '둘째주', '셋째주', '넷째주', '다섯째주'];
  final List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

  // 정기휴무 유무
  RxBool hasHoliday = false.obs;
  // 주차별 정기휴무 여부
  RxList<bool> isHolidayWeek = [false, false, false, false, false, false].obs;
  // 요일별 정기휴무 여부
  RxList<bool> isHolidayDay =
      [false, false, false, false, false, false, false].obs;
  // 선택된 정기휴무 정보
  final RxString holidaysInfo = ''.obs;

  final RxBool loaded = true.obs; // 조회 완료 여부

  // 정기휴무 조회 및 초기화
  Future<void> findHolidays(int storeId) async {
    loaded.value = false;
    isHolidayWeek.value = [false, false, false, false, false, false];
    isHolidayDay.value = [false, false, false, false, false, false, false];
    holidays = await _storeRepository.findHolidays(storeId);
    // 조회 성공
    if (holidays != null) {
      hasHoliday.value = holidays!.holidays != '';
      if (hasHoliday.value) {
        for (String holiday in holidays!.holidays.split(' ')) {
          isHolidayWeek[int.parse(holiday[0])] = true;
          isHolidayDay[int.parse(holiday[1])] = true;
        }
      }
    }
    loaded.value = true;
  }

  // 정기휴무 수정
  Future<dynamic> updateHolidays(int storeId) async {
    Map<String, String> data = {'holidays': holidaysInfo.value};
    dynamic today = await _storeRepository.updateHolidays(storeId, data);
    return today;
  }

  // 정기휴무 유무 변경
  void changeHasHoliday(bool value) {
    hasHoliday.value = value;
    if (hasHoliday.value) {
      isHolidayWeek.value = [false, false, false, false, false, false];
      isHolidayDay.value = [false, false, false, false, false, false, false];
    }
  }

  // 정기휴무 주차 변경
  void toggleIsHolidayWeek(int index) {
    isHolidayWeek[index] = !isHolidayWeek[index];

    if (index == 0) {
      for (int i = 1; i < 6; i++) {
        isHolidayWeek[i] = isHolidayWeek[0];
      }
    } else {
      if (isHolidayWeek[1] &&
          isHolidayWeek[2] &&
          isHolidayWeek[3] &&
          isHolidayWeek[4] &&
          isHolidayWeek[5]) {
        isHolidayWeek[0] = true;
      } else {
        isHolidayWeek[0] = false;
      }
    }
  }

  // 정기휴무 요일 변경
  void toggleIsHolidayDay(int index) {
    isHolidayDay[index] = !isHolidayDay[index];
  }

  // 다이얼로그에 표시할 정기휴무 정보 생성
  String makeHolidayInfoText() {
    String content = '';
    holidaysInfo.value = '';
    if (isHolidayWeek[0]) {
      for (int d = 0; d < 7; d++) {
        if (isHolidayDay[d]) {
          content += '* ${weeks[0]} ${days[d]}\n';
          holidaysInfo.value += '0$d 1$d 2$d 3$d 4$d 5$d ';
        }
      }
    } else {
      for (int w = 1; w < 6; w++) {
        if (isHolidayWeek[w]) {
          for (int d = 0; d < 7; d++) {
            if (isHolidayDay[d]) {
              content += '* ${weeks[w]} ${days[d]}\n';
              holidaysInfo.value += '$w$d ';
            }
          }
        }
      }
    }
    return content;
  }

  // 정기휴무 등록 페이지에서 입력된 정보 SaveStoreReqDto 객체에 추가
  SaveStoreReqDto setHolidaysInfo(SaveStoreReqDto dto) {
    dto.setHolidaysInfo(holidaysInfo.value);
    return dto;
  }
}
