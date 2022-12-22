import 'package:get/get.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/data/notice/notice_repository.dart';

class NoticeController extends GetxController {
  final NoticeRepository _noticeRepository = NoticeRepository();
  final int storeId;
  final noticeList = <Notice>[].obs;
  final RxBool loaded = true.obs; // 조회 완료 여부
  final RxBool connected = true.obs; // 네트워크 연결 여부

  NoticeController(this.storeId);

  @override
  void onInit() {
    super.onInit();
    // 알림 전체조회
    findAll(storeId);
    print('NoticeController onInit() 호출');
  }

  // 알림 전체조회
  Future<void> findAll(int storeId) async {
    loaded.value = false;
    connected.value = true;
    List<Notice>? result = await _noticeRepository.findAll(storeId);
    if (result != null) {
      noticeList.value = result;
    } else {
      noticeList.value = [];
      connected.value = false;
    }
    loaded.value = true;
  }
}
