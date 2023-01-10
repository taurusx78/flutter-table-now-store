import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/controller/store/location_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_text_area.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/image_uploader.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/validator_util.dart';

import 'components/register_appbar.dart';
import 'components/step_indicator.dart';

class EnterBasicPage extends GetView<BasicController> {
  EnterBasicPage({Key? key}) : super(key: key);

  final SaveStoreReqDto store = Get.arguments;

  final _descriptionFormKey = GlobalKey<FormState>();
  final _websiteFormKey = GlobalKey<FormState>();
  final LocationController _locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: RegisterAppBar(title: '기본정보'),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Obx(
                () => _locationController.loaded.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 안내 문구
                          _buildGuideText(),
                          const SizedBox(height: 50),
                          // 이전 화면에서 입력된 기본정보
                          _buildStoreInfoBox(),
                          const SizedBox(height: 50),
                          // 대표 사진
                          ImageUploader(
                            type: 'basic',
                            title: '대표사진',
                            guideText: '최대 3장, 한 장당 5MB 이하',
                            controller: controller,
                          ),
                          const SizedBox(height: 50),
                          // 기본정보 폼
                          _buildBasicInfoForm(context),
                        ],
                      )
                    : const SizedBox(
                        height: 200,
                        child: LoadingIndicator(),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 페이지 인덱스
        const StepIndicator(step: 0),
        const SizedBox(height: 20),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '입력한 정보를 확인하고\n나머지 ',
            style: TextStyle(fontSize: 22, color: Colors.black),
            children: [
              TextSpan(
                text: '기본정보',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '를 추가해주세요.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: blueGrey, width: 2),
          bottom: BorderSide(color: blueGrey, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 매장명
          _buildStoreInfoText('매장명', store.name),
          const SizedBox(height: 40),
          // 카테고리 (업종)
          _buildStoreInfoText('카테고리(업종)', store.category),
          const SizedBox(height: 40),
          // 전화번호
          _buildStoreInfoText('전화번호', store.phone),
          const SizedBox(height: 40),
          // 주소
          _buildStoreInfoText('주소', store.address + ', ' + store.detailAddress),
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
        ],
      ),
    );
  }

  Widget _buildStoreInfoText(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  Widget _buildBasicInfoForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 매장 소개
        const Text(
          '매장 소개',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: _descriptionFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextArea(
            hint: '고객들에게 매장을 소개해 주세요.',
            controller: controller.description,
            validator: validateTextField(),
          ),
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
        Form(
          key: _websiteFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '웹사이트 URL을 입력해 주세요.',
            controller: controller.website,
            keyboardType: TextInputType.url,
            maxLength: 50,
            validator: validateWebsite(),
          ),
        ),
        const SizedBox(height: 70),
        // 다음 버튼
        RoundButton(
          text: '다음',
          tapFunc: () {
            if (controller.imageList.isNotEmpty) {
              if (_descriptionFormKey.currentState!.validate() &&
                  _websiteFormKey.currentState!.validate()) {
                if (controller.imageList.length > 3) {
                  showToast(context, '대표사진을 3장 이하로 올려주세요.', null);
                } else {
                  controller.setBasicInfo(store);
                  Get.toNamed(Routes.enterInside, arguments: store);
                }
              }
            } else {
              showToast(context, '대표사진을 최소 1장 올려주세요.', null);
            }
          },
        ),
      ],
    );
  }
}
