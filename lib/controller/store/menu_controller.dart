import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_now_store/controller/dto/store/update_menu_req_dto.dart';
import 'package:table_now_store/data/store/model/menu.dart';
import 'package:table_now_store/data/store/store_repository.dart';

class MenuController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  Menu? menu;

  // 업로드된 메뉴사진 목록 (XFile 타입 ) or 조회한 메뉴사진 목록 (String 타입)
  RxList<dynamic> imageList = [].obs;
  final ImagePicker _picker = ImagePicker();

  final RxBool loaded = true.obs; // 조회 완료 여부

  // 갤러리에서 사진 선택
  Future<void> selectImages() async {
    final List<dynamic>? _selectedImages = await _picker.pickMultiImage();
    if (_selectedImages != null) {
      imageList.addAll(_selectedImages);
    }
  }

  // 메뉴 조회 및 초기화
  Future<void> findMenu(int storeId) async {
    loaded.value = false;
    menu = await _storeRepository.findMenu(storeId);
    // 조회 성공
    if (menu != null) {
      // 리스트 깊은 복사 (같은 주소 공간 참조하지 않음)
      imageList.value = [...menu!.imageUrlList];
    }
    loaded.value = true;
  }

  // 메뉴 수정
  Future<int> updateMenu(int storeId) async {
    List<String> deletedImageUrlList = [
      ...menu!.imageUrlList
    ]; // 삭제된 이미지 Url 리스트 초기화
    List<File> fileList = []; // 추가된 이미지 파일 리스트

    for (var item in imageList) {
      if (item.runtimeType == String) {
        deletedImageUrlList.remove(item);
      } else {
        fileList.add(File(item.path));
      }
    }
    // File 타입을 MultipartFile 타입으로 변경
    List<MultipartFile> multipartFileList = fileList
        .map((file) =>
            MultipartFile(file.path, filename: file.path.split('/').last))
        .toList();

    UpdateMenuReqDto dto = UpdateMenuReqDto(
      imageFileList: multipartFileList,
      deletedImageUrlList: deletedImageUrlList,
    );
    int result = await _storeRepository.updateMenu(storeId, dto.toJson());
    return result;
  }
}
