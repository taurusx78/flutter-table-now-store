import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/controller/store/location_controller.dart';
import 'package:table_now_store/ui/components/address_search_button.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_area.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/image_uploader.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/phone_text_form_field.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/manage/store_info/components/modified_text.dart';
import 'package:table_now_store/util/validator_util.dart';

class BasicInfoPage extends GetView<BasicController> {
  BasicInfoPage({Key? key}) : super(key: key);

  final int storeId = Get.arguments;

  final _formKey = GlobalKey<FormState>();
  final LocationController _locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('기본정보'),
          elevation: 0.5,
        ),
        body: Obx(
          () => controller.loaded.value
              ? Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Container(
                      width: 600,
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 최종수정일
                          ModifiedText(
                              modifiedDate: controller.basic!.modifiedDate),
                          const SizedBox(height: 50),
                          // 매장명
                          _buildStoreInfoBox('매장명', controller.basic!.name),
                          const SizedBox(height: 50),
                          // 카테고리 (업종)
                          _buildStoreInfoBox(
                              '카테고리(업종)', controller.basic!.category),
                          const SizedBox(height: 50),
                          // 기본정보 폼
                          _buildBasicInfoForm(context),
                        ],
                      ),
                    ),
                  ),
                )
              : const LoadingIndicator(),
        ),
      ),
    );
  }

  Widget _buildStoreInfoBox(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: 600,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: lightGrey,
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoForm(context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전화번호
          const Text(
            '전화번호',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const PhoneTextFormField(),
          const SizedBox(height: 50),
          // 주소
          const Text(
            '주소',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // 주소찾기 버튼
          const AddressSearchButton(),
          const SizedBox(height: 10),
          // 상세주소 텍스트필드
          CustomTextFormField(
            hint: '상세주소를 입력해 주세요.',
            controller: controller.detailAddress,
            focusNode: controller.detailAddressFocusNode,
            keyboardType: TextInputType.streetAddress,
            maxLength: 50,
            validator: validateTextField(),
          ),
          const SizedBox(height: 10),
          // 지도 불러오기
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blueGrey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(
                _locationController.bytesImage.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 50),
          // 대표 사진
          ImageUploader(
            type: 'basic',
            title: '대표사진',
            guideText: '최대 3장, 한 장당 5MB 이하',
            controller: controller,
          ),
          const SizedBox(height: 50),
          // 매장 소개
          const Text(
            '매장 소개',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CustomTextArea(
            hint: '고객들에게 매장을 소개해 주세요.',
            controller: controller.description,
            validator: validateTextField(),
          ),
          const SizedBox(height: 40),
          // 웹사이트
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '웹사이트',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '  * 선택',
                style: TextStyle(fontSize: 14, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            hint: '웹사이트 URL을 입력해 주세요.',
            controller: controller.website,
            keyboardType: TextInputType.url,
            maxLength: 100,
            validator: validateWebsite(),
          ),
          const SizedBox(height: 70),
          // 수정 버튼
          RoundButton(
            text: '수정',
            tapFunc: () {
              if (_formKey.currentState!.validate()) {
                if (controller.imageList.isNotEmpty) {
                  _showDialog(context);
                } else {
                  showToast(context, '대표사진을 최소 1장 올려주세요.', null);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '기본정보를 수정하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            _showProcessingDialog(context);
          },
        );
      },
    );
  }

  void _showProcessingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context2) {
        // 기본정보 수정 진행
        controller.updateBasic(storeId).then((value) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          Get.back(result: value);
        });

        return const LoadingContainer(text: '수정중');
      },
    );
  }
}
