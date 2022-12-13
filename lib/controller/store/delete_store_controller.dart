import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class DeleteStoreController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final password = TextEditingController();
  final curPwFormKey = GlobalKey<FormState>();
  final RxBool activated = false.obs; // 매장삭제 버튼 활성화 여부

  @override
  void onInit() {
    super.onInit();
    // 텍스트필드 입력 감지 및 버튼 상태 변경 리스너 등록
    password.addListener(checkButtonActivated);
  }

  // 매장삭제
  Future<int> deleteById(int storeId) async {
    Map<String, String> data = {'password': password.text};
    int result = await _storeRepository.deleteById(storeId, data);
    return result;
  }

  // 매장삭제 버튼 활성화 여부 확인
  void checkButtonActivated() {
    // 비밀번호 8~20자로 입력된 경우, 버튼 활성화
    activated.value = password.text.length >= 8;
  }
}
