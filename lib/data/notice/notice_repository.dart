import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_provider.dart';

class NoticeRepository {
  final NoticeProvider _noticeProvider = NoticeProvider();

  // 알림 전체조회
  Future<List<Notice>?> findAll(int storeId) async {
    Response response = await _noticeProvider.findAll(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 1) {
        List<dynamic> temp = dto.response;
        return temp.map((notice) => Notice.fromJson(notice)).toList();
      }
    }
    return null; // 네트워크 연결 안됨
  }

  // 알림 등록
  Future<int> save(int storeId, Map<String, dynamic> data) async {
    Response response = await _noticeProvider.save(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 등록 성공 (1), 유효성검사 실패 (-1), 권한 없음 (-2)
    } else {
      return -3; // 네트워크 연결 안됨
    }
  }

  // 알림 수정
  Future<int> updateById(
      int storeId, int noticeId, Map<String, dynamic> data) async {
    Response response =
        await _noticeProvider.updateById(storeId, noticeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 수정 성공 (1), 유효성검사 실패 (-1), 권한 없음 (-2)
    } else {
      return -3; // 네트워크 연결 안됨
    }
  }

  // 알림 삭제
  Future<int> deleteById(int storeId, int noticeId) async {
    Response response = await _noticeProvider.deleteById(storeId, noticeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 수정 성공 (1), 권한 없음 (-2)
    } else {
      return -3; // 네트워크 연결 안됨
    }
  }
}
