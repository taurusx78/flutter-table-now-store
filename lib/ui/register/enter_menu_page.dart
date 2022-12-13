import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/store/menu_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/image_uploader.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';

import 'components/register_appbar.dart';
import 'components/step_indicator.dart';

class EnterMenuPage extends GetView<MenuController> {
  EnterMenuPage({Key? key}) : super(key: key);

  final SaveStoreReqDto store = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(title: '메뉴정보'),
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
                _buildMenuInfoBox(context),
              ],
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
        const StepIndicator(step: 2),
        const SizedBox(height: 20),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '메뉴사진',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '을 등록해주세요.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuInfoBox(context) {
    return Column(
      children: [
        // 메뉴사진
        ImageUploader(
          type: 'menu',
          title: '메뉴사진',
          guideText: '최대 20장, 한 장당 5MB 이하',
          controller: controller,
        ),
        const SizedBox(height: 70),
        // 다음 버튼
        RoundButton(
          text: '다음',
          tapFunc: () {
            if (controller.imageList.isNotEmpty) {
              controller.setMenuInfo(store);
              Get.toNamed(Routes.enterHolidays, arguments: store);
            } else {
              showToast(context, '메뉴 사진을 최소 1장 올려주세요.', null);
            }
          },
        ),
      ],
    );
  }
}
