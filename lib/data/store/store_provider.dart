import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';

class StoreProvider extends GetConnect {
  // 나의 매장 전체조회
  Future<Response> findAllMyStore(String? jwtToken) =>
      get('$host/manager/store', headers: {'authorization': jwtToken ?? ''});

  // 오늘의 영업시간 조회
  Future<Response> findToday(int id) => get('$host/store/$id/todayHours');

  // 잔여테이블 수 조회
  Future<Response> findTables(int id) => get('$host/store/$id/tables');
}
