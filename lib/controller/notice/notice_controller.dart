import 'package:get/get.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_repository.dart';

class NoticeController extends GetxController {
  final NoticeRepository _noticeRepository = NoticeRepository();
  final noticeList = <Notice>[].obs;
  final RxBool loaded = true.obs; // 조회 완료 여부

  // 알림 전체조회
  Future<void> findAll(int storeId) async {
    loaded.value = false;
    noticeList.value = await _noticeRepository.findAll(storeId);
    loaded.value = true;
  }
}
