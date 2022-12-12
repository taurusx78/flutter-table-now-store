import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/my_store_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/update_basic_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/update_inside_resp_dto.dart';
import 'package:table_now_store/data/store/store_provider.dart';

import 'model/basic.dart';
import 'model/holidays.dart';
import 'model/hours.dart';
import 'model/inside.dart';
import 'model/menu.dart';
import 'model/tables.dart';
import 'model/today.dart';

class StoreRepository {
  final StoreProvider _storeProvider = StoreProvider();

  // 나의 매장 전체조회
  Future<List<MyStoreRespDto>> findAllMyStore(String? jwtToken) async {
    Response response = await _storeProvider.findAllMyStore(jwtToken);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      List<dynamic> temp = dto.response;
      return temp.map((store) => MyStoreRespDto.fromJson(store)).toList();
    } else {
      return <MyStoreRespDto>[]; // MyStoreRespDto 빈 배열 반환
    }
  }

  // 오늘의 영업시간 조회
  Future<Today?> findToday(int storeId) async {
    Response response = await _storeProvider.findToday(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Today.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 오늘의 영업시간 수정
  Future<dynamic> updateToday(int storeId, Map data) async {
    Response response = await _storeProvider.updateToday(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    // 성공 (Today), 임시휴무 알림 존재 (-2), 실패 (-1)
    if (dto.code == 1) {
      return Today.fromJson(dto.response);
    } else {
      return dto.code;
    }
  }

  // 잔여테이블 수 조회
  Future<Tables?> findTables(int storeId) async {
    Response response = await _storeProvider.findTables(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Tables.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 잔여테이블 수 수정
  Future<dynamic> updateTables(int storeId, Map data) async {
    Response response = await _storeProvider.updateTables(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    // 성공 시 Tables, 수정 불가 (임시중지중) -2, 실패 -1 리턴
    if (dto.code == 1) {
      return Tables.fromJson(dto.response);
    } else {
      return dto.code;
    }
  }

  // 영업시간 조회
  Future<Hours?> findHours(int storeId) async {
    Response response = await _storeProvider.findHours(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Hours.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 영업시간 수정
  Future<dynamic> updateHours(int storeId, Map data) async {
    Response response = await _storeProvider.updateHours(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Today.fromJson(dto.response);
    } else {
      return -1; // 실패 시 -1 리턴
    }
  }

  // 정기휴무 조회
  Future<Holidays?> findHolidays(int storeId) async {
    Response response = await _storeProvider.findHolidays(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Holidays.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 정기휴무 수정
  Future<dynamic> updateHolidays(int storeId, Map data) async {
    Response response = await _storeProvider.updateHolidays(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Today.fromJson(dto.response);
    } else {
      return -1; // 실패 시 -1 리턴
    }
  }

  // 메뉴 조회
  Future<Menu?> findMenu(int storeId) async {
    Response response = await _storeProvider.findMenu(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Menu.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 메뉴 수정
  Future<int> updateMenu(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateMenu(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
    return dto.code; // 성공 (1), 실패 (-1)
  }

  // 매장내부정보 조회
  Future<Inside?> findInside(int storeId) async {
    Response response = await _storeProvider.findInside(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Inside.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 매장내부정보 수정
  Future<dynamic> updateInside(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateInside(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return UpdateInsideRespDto.fromJson(dto.response);
    } else {
      return -1; // 실패 시 -1 리턴
    }
  }

  // 기본정보 조회
  Future<Basic?> findBasic(int storeId) async {
    Response response = await _storeProvider.findBasic(storeId);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return Basic.fromJson(dto.response);
    } else {
      return null;
    }
  }

  // 기본정보 수정
  Future<dynamic> updateBasic(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateBasic(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);

    if (dto.code == 1) {
      return UpdateBasicRespDto.fromJson(dto.response);
    } else {
      return -1; // 실패 시 -1 리턴
    }
  }

  // 매장삭제
  Future<int> deleteById(int storeId, Map data) async {
    Response response = await _storeProvider.deleteById(storeId, data);
    CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
    return dto.code; // 성공 (1), 권한없음 (-1), 비밀번호 불일치 (-2)
  }
}
