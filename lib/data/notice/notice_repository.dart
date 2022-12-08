import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_provider.dart';

class NoticeRepository {
  final NoticeProvider _noticeProvider = NoticeProvider();

  // 알림 전체조회
  Future<List<Notice>> findAll(int storeId) async {
    Response response = await _noticeProvider.findAll(storeId);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);

    if (codeMsgRespDto.code == 1) {
      List<dynamic> temp = codeMsgRespDto.response;
      return temp.map((notice) => Notice.fromJson(notice)).toList();
    } else {
      return <Notice>[]; // Notice 빈 배열 반환
    }
  }

  // 알림 등록
  Future<int> save(int storeId, Map<String, dynamic> data) async {
    Response response = await _noticeProvider.save(storeId, data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code;
  }

  // 알림 수정
  Future<int> updateById(
      int storeId, int noticeId, Map<String, dynamic> data) async {
    Response response =
        await _noticeProvider.updateById(storeId, noticeId, data);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code;
  }

  // 알림 삭제
  Future<int> deleteById(int storeId, int noticeId) async {
    Response response = await _noticeProvider.deleteById(storeId, noticeId);
    CodeMsgRespDto codeMsgRespDto = CodeMsgRespDto.fromJson(response.body);
    return codeMsgRespDto.code;
  }
}
