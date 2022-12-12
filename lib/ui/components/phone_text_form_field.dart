import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/data/area_code.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';
import 'package:table_now_store/util/validator_util.dart';

import 'custom_text_form_field.dart';

class PhoneTextFormField extends GetView<BasicController> {
  const PhoneTextFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 지역번호 Picker
        _buildAreaCodePicker(context),
        const SizedBox(width: 10),
        // 전화 텍스트필드
        CustomTextFormField(
          hint: '- 제외',
          controller: controller.phone,
          focusNode: controller.phoneFocusNode,
          keyboardType: TextInputType.phone,
          maxLength: 8,
          counterText: '',
          validator: validateStorePhone(),
          width: getScreenWidth(context) - 150 < 490
              ? getScreenWidth(context) - 150
              : 490,
        ),
      ],
    );
  }

  Widget _buildAreaCodePicker(context) {
    return GestureDetector(
      child: Container(
        width: 100,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: blueGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                controller.areaCode.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black54,
              size: 20,
            ),
          ],
        ),
      ),
      onTap: () async {
        _showAreaCodeDialog(context).then((value) {
          // 전화번호 텍스트필드 포커스 주기
          controller.phoneFocusNode.requestFocus();
        });
      },
    );
  }

  Future<void> _showAreaCodeDialog(context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: const Text(
            '지역번호',
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
              itemCount: areaCode.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => RadioListTile(
                    title: Text(areaCode[index]),
                    value: areaCode[index].split(' ')[0],
                    groupValue: controller.areaCode.value,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      controller.changeAreaCode(areaCode[index]);
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
}
