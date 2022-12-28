import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/controller/store/location_controller.dart';
import 'package:table_now_store/controller/store/save_store_controller.dart';
import 'package:table_now_store/data/category.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/address_search_button.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/phone_text_form_field.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/components/warning_row_text.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';
import 'package:table_now_store/util/validator_util.dart';

class CheckRegisteredPage extends GetView<BasicController> {
  CheckRegisteredPage({Key? key}) : super(key: key);

  final _nameFormKey = GlobalKey<FormState>();
  final _categoryFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _detailAddressFormKey = GlobalKey<FormState>();

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
              Icons.clear_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 안내 문구
                  _buildGuideText(),
                  const SizedBox(height: 50),
                  // 매장등록 폼
                  _buildRegisterForm(context),
                  const SizedBox(height: 30),
                  // 경고 문구
                  const WarningRowText(
                    text: '타인의 업체를 도용하여 가입한 경우, 서비스 이용 제한 및 법적 제재를 받으실 수 있습니다.',
                    margin: 40,
                  ),
                  const SizedBox(height: 70),
                  // 조회 버튼
                  _buildCheckExistButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideText() {
    return RichText(
      text: const TextSpan(
        text: '먼저 ',
        style: TextStyle(fontSize: 22, color: Colors.black),
        children: [
          TextSpan(
            text: '기존 등록 여부',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '를\n조회해주세요.'),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 매장명
        const Text(
          '매장명',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: _nameFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '정확한 매장명을 입력해 주세요.',
            controller: controller.name,
            maxLength: 50,
            validator: validateTextField(),
          ),
        ),
        const SizedBox(height: 40),
        // 카테고리(업종)
        const Text(
          '카테고리(업종)',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: _categoryFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '카테고리를 선택해 주세요.',
            controller: controller.category,
            readOnly: true,
            validator: validateTextField(),
            tapFunc: () {
              _showCategoryDialog(context);
              // 텍스트필드 포커스 해제
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        const SizedBox(height: 50),
        // 전화번호
        const Text(
          '전화번호',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: _phoneFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: const PhoneTextFormField(),
        ),
        const SizedBox(height: 50),
        // 주소
        const Text(
          '주소',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // 주소찾기 버튼
        Form(
          key: _addressFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: const AddressSearchButton(),
        ),
        const SizedBox(height: 10),
        // 상세주소 텍스트필드
        Form(
          key: _detailAddressFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Obx(
            () => controller.jibunAddress.value != ''
                ? CustomTextFormField(
                    hint: '상세주소를 입력해 주세요.',
                    controller: controller.detailAddress,
                    focusNode: controller.detailAddressFocusNode,
                    keyboardType: TextInputType.streetAddress,
                    maxLength: 50,
                    validator: validateStoreAddress(),
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  void _showCategoryDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: const Text(
            '카테고리(업종)',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: getScreenWidth(context) * 0.8,
            height: getScreenHeight(context) * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: blueGrey),
                bottom: BorderSide(color: blueGrey),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: category.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => RadioListTile(
                    title: Text(category[index]),
                    value: category[index],
                    groupValue: controller.rxCategory.value,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      controller.changeCategory(category[index]);
                    },
                  ),
                );
              },
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 15),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    '선택',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // alertDialog 닫기
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildCheckExistButton(context) {
    SaveStoreController _saveStoreController = Get.put(SaveStoreController());

    return Obx(
      () => _saveStoreController.loaded.value
          ? StateRoundButton(
              text: '등록여부 조회하기',
              activated: controller.activated.value,
              tapFunc: () {
                // 등록여부조회
                _saveStoreController
                    .checkExist(
                  controller.name.text,
                  controller.category.text,
                  '${controller.areaCode.value}-${controller.phone.text.replaceAllMapped(RegExp(r'(\d{3,4})(\d{4})'), (m) => '${m[1]}-${m[2]}')}',
                  controller.address.text,
                )
                    .then((result) {
                  if (result == 0) {
                    _showDialog(
                        context, '매장 등록이 가능합니다.', '입력한 정보로 신규 매장을 등록하시겠습니까?',
                        () async {
                      Navigator.pop(context);
                      // 네이버지도 이미지 불러오기
                      Get.put(LocationController()).getLocationMap(
                          controller.longitude.value,
                          controller.latitude.value);
                      // 기본정보 입력 페이지로 이동 및 SaveStoreReqDto 객체 전달
                      Get.toNamed(Routes.enterBasic,
                          arguments: controller.makeSaveStoreReqDto());
                    });
                  } else if (result == 1) {
                    _showDialog(context, '이미 등록된 매장입니다.', '입력한 정보를 다시 확인해 주세요.',
                        () {
                      Navigator.pop(context);
                    });
                  } else if (result == 500) {
                    showNetworkDisconnectedToast(context);
                  } else {
                    showErrorToast(context);
                  }
                });
              },
            )
          : const LoadingRoundButton(),
    );
  }

  void _showDialog(context, String title, String content, dynamic checkFunc) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: content,
          checkFunc: checkFunc,
        );
      },
    );
  }
}
