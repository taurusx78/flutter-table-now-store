import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpostal/kpostal.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/util/validator_util.dart';

import 'custom_text_form_field.dart';

class AddressSearchButton extends GetView<BasicController> {
  const AddressSearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hint: '매장 주소를 입력해 주세요.',
      controller: controller.address,
      readOnly: true,
      validator: validateStoreAddress(),
      tapFunc: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KpostalView(
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
                title: const Text('주소검색'),
              ),
              callback: (Kpostal result) {
                controller.address.text = result.address;
                controller.latitude.value = result.latitude!;
                controller.longitude.value = result.longitude!;
                List<String> jibunParts = result.jibunAddress.split(' ');
                controller.jibunAddress.value =
                    '${jibunParts[0]} ${jibunParts[1]} ${jibunParts[2]}';
              },
            ),
          ),
        );
        // 상세주소 텍스트필드 포커스 주기
        controller.detailAddressFocusNode.requestFocus();
      },
    );
  }
}
