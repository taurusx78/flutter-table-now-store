import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/store/inside_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/image_uploader.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/table_count_text_field.dart';

import 'components/register_appbar.dart';
import 'components/step_indicator.dart';

class EnterInsidePage extends GetView<InsideController> {
  EnterInsidePage({Key? key}) : super(key: key);

  final SaveStoreReqDto store = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: RegisterAppBar(title: '매장내부정보'),
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
                  _buildInsideInfoForm(context),
                ],
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
        const StepIndicator(step: 1),
        const SizedBox(height: 20),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '매장의 ',
            style: TextStyle(fontSize: 22, color: Colors.black),
            children: [
              TextSpan(
                text: '전체테이블 수',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '와\n',
              ),
              TextSpan(
                text: '내부사진',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '을 등록해주세요.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsideInfoForm(context) {
    return Column(
      children: [
        // 전체테이블 수
        TableCountTextField(),
        const SizedBox(height: 50),
        // 매장 내부 사진
        ImageUploader(
          type: 'inside',
          title: '매장내부사진',
          guideText: '최대 10장, 한 장당 5MB 이하',
          controller: controller,
        ),
        const SizedBox(height: 70),
        // 다음 버튼
        RoundButton(
          text: '다음',
          tapFunc: () {
            // 테이블 수 입력 여부
            if (controller.allTableCount.text.isNotEmpty) {
              // 테이블 수 0~500 범위의 숫자 여부
              if (controller.validateAllTableCount()) {
                if (controller.imageList.isNotEmpty) {
                  if (controller.imageList.length > 3) {
                    showToast(context, '내부사진을 10장 이하로 올려주세요.', null);
                  } else {
                    controller.setInsideInfo(store);
                    Get.toNamed(Routes.enterMenu, arguments: store);
                  }
                } else {
                  showToast(context, '내부사진을 최소 1장 올려주세요.', null);
                }
              } else {
                showToast(context, '전체테이블 수는 0~500 범위의\n숫자로 입력해 주세요.', 1500);
              }
            } else {
              showToast(context, '전체테이블 수를 입력해 주세요.', null);
            }
          },
        ),
      ],
    );
  }
}
