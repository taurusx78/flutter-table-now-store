import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_provider.dart';
import 'package:table_now_store/data/store/model/today.dart';

class NoticeRepository {
  final NoticeProvider _noticeProvider = NoticeProvider();

  // 알림 전체조회
  Future<List<Notice>?> findAll(int storeId) async {
    Response response = await _noticeProvider.findAll(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        return temp.map((notice) => Notice.fromJson(notice)).toList();
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 알림 등록
  Future<dynamic> save(int storeId, Map<String, dynamic> data) async {
    Response response = await _noticeProvider.save(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 201) {
        Today today = Today.fromJson(dto.response);
        return today; // 등록 완료 (Today)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 알림 수정
  Future<dynamic> updateById(
      int storeId, int noticeId, Map<String, dynamic> data) async {
    Response response =
        await _noticeProvider.updateById(storeId, noticeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response); // 수정 완료 (Today)
      }
      return dto.code; // 알림 없음 (404), 이미 로그아웃 또는 탈퇴 (403)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }

  // 알림 삭제
  Future<dynamic> deleteById(int storeId, int noticeId) async {
    Response response = await _noticeProvider.deleteById(storeId, noticeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Today.fromJson(dto.response); // 삭제 완료 (Today)
      }
      return dto.code; // 이미 로그아웃 또는 탈퇴 (403), 알림 없음 (404)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }
}
