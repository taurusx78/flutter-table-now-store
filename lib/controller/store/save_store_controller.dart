import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class SaveStoreController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final RxBool loaded = true.obs; // 조회 완료 여부

  // 등록여부조회
  Future<int> checkExist(
      String name, String category, String phone, String address) async {
    loaded.value = false;
    int result =
        await _storeRepository.checkExist(name, category, phone, address);
    loaded.value = true;
    return result;
  }

  // 매장등록
  Future<int> save(SaveStoreReqDto dto) async {
    return await _storeRepository.save(dto.toJson());
  }
}
