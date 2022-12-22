import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_now_store/controller/dto/store/my_store_resp_dto.dart';
import 'package:table_now_store/data/store/store_repository.dart';
import 'package:table_now_store/util/jwtToken.dart';

class MainController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  SharedPreferences? pref; // 로컬저장소에서 회원 정보 불러옴

  // 로그인한 회원 정보
  final RxString username = ''.obs; // 아이디
  final RxString name = ''.obs; // 이름
  final RxString phone = ''.obs; // 휴대폰번호
  final RxString email = ''.obs; // 이메일

  final myStoreList = <MyStoreRespDto>[].obs;

  final RxInt curIndex = 0.obs; // 메인 페이지 네이게이션바 현재 인덱스
  final RxBool userLoaded = true.obs; // 회원 정보 조회 완료 여부
  final RxBool loaded = false.obs; // 매장 조회 완료 여부
  final RxBool connected = true.obs; // 네트워크 연결 여부

  @override
  void onInit() async {
    super.onInit();
    // 1. 회원 정보 불러오기
    pref = await SharedPreferences.getInstance();
    List<String> userInfo = pref!.getStringList('user')!;
    username.value = userInfo[0];
    name.value = userInfo[1];
    phone.value = userInfo[2];
    email.value = userInfo[3];
    userLoaded.value = true;
    // 2. 나의 매장 전체조회
    findAllMyStore();
  }

  // 나의 매장 전체조회
  Future<void> findAllMyStore() async {
    loaded.value = false;
    connected.value = true;
    var result = await _storeRepository.findAllMyStore(jwtToken);
    if (result.runtimeType == List<MyStoreRespDto>) {
      myStoreList.value = result;
    } else if (result == -2) {
      myStoreList.value = [];
    } else if (result == -3) {
      myStoreList.value = [];
      connected.value = false;
    }
    loaded.value = true;
  }

  // 네이게이션바 현재 인덱스 변경
  void changeCurIndex(int index) {
    curIndex.value = index;
  }

  // 휴대폰번호 수정 반영
  void changePhone(String phone) async {
    pref = await SharedPreferences.getInstance();
    pref!.setStringList(
        'user', [username.value, name.value, phone, email.value]);
    this.phone.value = phone;
  }

  // 이메일 수정 반영
  void changeEmail(String email) async {
    pref = await SharedPreferences.getInstance();
    pref!.setStringList(
        'user', [username.value, name.value, phone.value, email]);
    this.email.value = email;
  }
}
