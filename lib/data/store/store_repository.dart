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
  Future<dynamic> findAllMyStore(String? jwtToken) async {
    Response response = await _storeProvider.findAllMyStore(jwtToken);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        return temp.map((store) => MyStoreRespDto.fromJson(store)).toList();
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    }
    return 500; // 네트워크 연결 안됨
  }

  // 등록여부조회
  Future<int> checkExist(
      String name, String category, String phone, String address) async {
    Response response =
        await _storeProvider.checkExist(name, category, phone, address);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return dto.response; // 매장 존재 (1), 등록 가능 (0)
      }
      return dto.code;
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 매장등록
  Future<int> save(Map<String, dynamic> data) async {
    Response response = await _storeProvider.save(data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 등록 완료 (200), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 오늘의 영업시간 조회
  Future<dynamic> findToday(int storeId) async {
    Response response = await _storeProvider.findToday(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 오늘의 영업시간 수정
  Future<dynamic> updateToday(int storeId, Map data) async {
    Response response = await _storeProvider.updateToday(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response); // 수정 완료 (Today)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403), 수정 불가 (417)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 잔여테이블 수 조회
  Future<Tables?> findTables(int storeId) async {
    Response response = await _storeProvider.findTables(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Tables.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 잔여테이블 수 수정
  Future<dynamic> updateTables(int storeId, Map data) async {
    Response response = await _storeProvider.updateTables(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Tables.fromJson(dto.response); // 수정 완료 (Tables)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 영업시간 조회
  Future<Hours?> findHours(int storeId) async {
    Response response = await _storeProvider.findHours(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Hours.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 영업시간 수정
  Future<dynamic> updateHours(int storeId, Map data) async {
    Response response = await _storeProvider.updateHours(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response); // 수정 완료 (Today)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 정기휴무 조회
  Future<Holidays?> findHolidays(int storeId) async {
    Response response = await _storeProvider.findHolidays(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Holidays.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 정기휴무 수정
  Future<dynamic> updateHolidays(int storeId, Map data) async {
    Response response = await _storeProvider.updateHolidays(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response); // 수정 완료 (Today)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 메뉴 조회
  Future<Menu?> findMenu(int storeId) async {
    Response response = await _storeProvider.findMenu(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Menu.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 메뉴 수정
  Future<int> updateMenu(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateMenu(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 수정 완료 (200), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 매장내부정보 조회
  Future<Inside?> findInside(int storeId) async {
    Response response = await _storeProvider.findInside(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Inside.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 매장내부정보 수정
  Future<dynamic> updateInside(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateInside(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return UpdateInsideRespDto.fromJson(
            dto.response); // 수정 완료 (UpdateInsideRespDto)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 기본정보 조회
  Future<Basic?> findBasic(int storeId) async {
    Response response = await _storeProvider.findBasic(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Basic.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 기본정보 수정
  Future<dynamic> updateBasic(int storeId, Map<String, dynamic> data) async {
    Response response = await _storeProvider.updateBasic(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return UpdateBasicRespDto.fromJson(
            dto.response); // 수정 완료 (UpdateBasicRespDto)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 매장삭제
  Future<int> deleteById(int storeId, Map data) async {
    Response response = await _storeProvider.deleteById(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 삭제 왼료 (200), 인증 실패 (401), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }
}
