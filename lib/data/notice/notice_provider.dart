import 'package:get/get.dart';
import 'package:table_now_store/util/host.dart';
import 'package:table_now_store/util/jwtToken.dart';

class NoticeProvider extends GetConnect {
  // 알림 전제조회
  Future<Response> findAll(int id) => get('$host/store/$id/notice');

  // 알림 등록
  Future<Response> save(int id, Map<String, dynamic> data) => post(
        '$host/manager/store/$id/notice', FormData(data),
        // 사진 파일이 포함된 데이터 전송을 위한 Content-Type 설정
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 알림 수정
  Future<Response> updateById(
          int storeId, int noticeId, Map<String, dynamic> data) =>
      put(
        '$host/manager/store/$storeId/notice/$noticeId',
        FormData(data),
        // 사진 파일이 포함된 데이터 전송
        contentType:
            'multipart/form-data; boundary=<calculated when request is sent>',
        headers: {'authorization': jwtToken ?? ''},
      );

  // 알림 삭제
  Future<Response> deleteById(int storeId, int noticeId) => delete(
        '$host/manager/store/$storeId/notice/$noticeId',
        headers: {'authorization': jwtToken ?? ''},
      );
}
