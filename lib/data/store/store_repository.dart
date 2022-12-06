import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/my_store_resp_dto.dart';
import 'package:table_now_store/data/store/model/tables.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/data/store/store_provider.dart';

class StoreRepository {
  final StoreProvider _storeProvider = StoreProvider();

  // 나의 매장 전체조회
  Future<List<MyStoreRespDto>> findAllMyStore(String? jwtToken) async {
    Response response = await _storeProvider.findAllMyStore(jwtToken);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      List<dynamic> temp = codeMsgRespDto.response;
      return temp.map((store) => MyStoreRespDto.fromJson(store)).toList();
    } else {
      return <MyStoreRespDto>[]; // MyStoreRespDto 빈 배열 반환
    }
  }

  // 오늘의 영업시간 조회
  Future<dynamic> findToday(int storeId) async {
    Response response = await _storeProvider.findToday(storeId);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      return Today.fromJson(codeMsgRespDto.response);
    } else {
      return null;
    }
  }

  // 잔여테이블 수 조회
  Future<dynamic> findTables(int storeId) async {
    Response response = await _storeProvider.findTables(storeId);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      return Tables.fromJson(codeMsgRespDto.response);
    } else {
      return null;
    }
  }
}
