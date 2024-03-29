import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';
import 'package:table_now_store/util/jwtToken.dart';

class StoreProvider extends GetConnect {
  // 나의 매장 전체조회
  Future<Response> findAllMyStore(String? jwtToken) async =>
      await get('$host/manager/store',
          headers: {'authorization': jwtToken ?? ''});

  // 나의 매장 1개 조회
  Future<Response> findOneMyStore(int id, String? jwtToken) async =>
      await get('$host/manager/store/$id',
          headers: {'authorization': jwtToken ?? ''});

  // 등록여부조회
  Future<Response> checkExist(
          String name, String category, String phone, String address) async =>
      await get(
          '$host/check/store?name=$name&category=$category&phone=$phone&address=$address');

  // 매장등록
  Future<Response> save(Map<String, dynamic> data) async => await post(
        '$host/manager/store', FormData(data),
        // 사진 파일이 포함된 데이터 전송을 위한 Content-Type 설정
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 오늘의 영업시간 조회
  Future<Response> findToday(int id) async =>
      await get('$host/store/$id/todayHours');

  // 오늘의 영업시간 수정
  Future<Response> updateToday(int id, Map data) async =>
      await put('$host/manager/store/$id/todayHours', data,
          headers: {'authorization': jwtToken ?? ''});

  // 잔여테이블 수 조회
  Future<Response> findTables(int id) async =>
      await get('$host/store/$id/tables');

  // 잔여테이블 수 수정
  Future<Response> updateTables(int id, Map data) async =>
      await put('$host/manager/store/$id/tables', data,
          headers: {'authorization': jwtToken ?? ''});

  // 영업시간 조회
  Future<Response> findHours(int id) async =>
      await get('$host/manager/store/$id/hours');

  // 영업시간 수정
  Future<Response> updateHours(int id, Map data) async => await put(
        '$host/manager/store/$id/hours',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 정기휴무 조회
  Future<Response> findHolidays(int id) async =>
      await get('$host/store/$id/holidays');

  // 정기휴무 수정
  Future<Response> updateHolidays(int id, Map data) async => await put(
        '$host/manager/store/$id/holidays',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );

  // 메뉴 조회
  Future<Response> findMenu(int id) async => await get('$host/store/$id/menu');

  // 메뉴 수정
  Future<Response> updateMenu(int id, Map<String, dynamic> data) async =>
      await put(
        '$host/manager/store/$id/menu',
        FormData(data),
        // 사진 파일이 포함된 데이터 전송을 위한 Content-Type 설정
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 매장내부정보 조회
  Future<Response> findInside(int id) async =>
      await get('$host/store/$id/inside');

  // 매장내부정보 수정
  Future<Response> updateInside(int id, Map<String, dynamic> data) async =>
      await put(
        '$host/manager/store/$id/inside', FormData(data),
        // 사진 파일이 포함된 데이터 전송을 위한 Content-Type 설정
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 기본정보 조회
  Future<Response> findBasic(int id) async =>
      await get('$host/store/$id/basic');

  // 기본정보 수정
  Future<Response> updateBasic(int id, Map<String, dynamic> data) async =>
      await put(
        '$host/manager/store/$id/basic', FormData(data),
        // 사진 파일이 포함된 데이터 전송을 위한 Content-Type 설정
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 매장삭제
  Future<Response> deleteById(int id, Map data) async => await post(
        '$host/manager/store/$id',
        data,
        headers: {'authorization': jwtToken ?? ''},
      );
}
