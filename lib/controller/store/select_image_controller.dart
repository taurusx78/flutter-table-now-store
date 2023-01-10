import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // 갤러리에서 사진 선택
  Future<dynamic> selectImages() async {
    RxList<dynamic> imageList = [].obs;
    final List<XFile>? _selectedImages = await _picker.pickMultiImage(
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 75, // 이미지 크기 압축을 위해 퀄리티를 75로 낮춤
    );
    if (_selectedImages != null) {
      imageList.addAll(_selectedImages);
    }
    return imageList;
  }
}
