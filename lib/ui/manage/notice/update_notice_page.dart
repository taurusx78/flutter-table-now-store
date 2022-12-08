import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';
import 'package:table_now_store/data/notice/notice.dart';
import 'package:table_now_store/ui/components/custom_text_area.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/two_round_buttons.dart';
import 'package:table_now_store/util/validator_util.dart';

import 'components/holiday_switch.dart';
import 'components/notice_dialog.dart';
import 'components/notice_image_uploader.dart';

class UpdateNoticePage extends GetView<SaveNoticeController> {
  UpdateNoticePage({Key? key}) : super(key: key);

  final int storeId = Get.arguments[0];
  final Notice notice = Get.arguments[1];

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
          title: const Text('알림 수정'),
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
                  // 임시휴무 유무
                  HolidaySwitch(),
                  const SizedBox(height: 50),
                  // 이미지 업로드
                  NoticeImageUploader(),
                  const SizedBox(height: 50),
                  // 알림 폼
                  _buildNoticeForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        const Text(
          '제목',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: controller.titleFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            maxLength: 50,
            hint: '제목을 입력해 주세요.',
            controller: controller.title,
            validator: validateNotice(),
          ),
        ),
        const SizedBox(height: 40),
        // 내용
        const Text(
          '내용',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: controller.contentFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextArea(
            hint: '내용을 입력해 주세요.',
            controller: controller.content,
            validator: validateNotice(),
          ),
        ),
        const SizedBox(height: 70),
        // 수정/삭제 버튼
        Obx(
          () => controller.completed.value
              ? TwoRoundButtons(
                  leftText: '삭제',
                  leftTapFunc: () {
                    _showDialog(context, '삭제');
                  },
                  rightText: '수정',
                  rightTapFunc: () {
                    if (controller.titleFormKey.currentState!.validate() &&
                        controller.contentFormKey.currentState!.validate()) {
                      _showDialog(context, '수정');
                    }
                  },
                  padding: 40,
                )
              : const LoadingRoundButton(),
        ),
      ],
    );
  }

  void _showDialog(context, String text) {
    // 임시휴무 정보 확인
    String holiday = controller.getHolidayInfo();

    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        if (text == '수정') {
          return NoticeDialog(
            title: '알림을 수정하시겠습니까?',
            noticeTitle: controller.title.text,
            holiday: holiday,
            tapFunc: () async {
              Navigator.pop(context2);
              int result = await controller.updateById(storeId, notice);
              Get.back(result: [text, result]);
            },
          );
        } else {
          return NoticeDialog(
            title: '알림을 삭제하시겠습니까?',
            tapFunc: () async {
              Navigator.pop(context2);
              int result = await controller.deleteById(storeId, notice.id);
              Get.back(result: [text, result]);
            },
          );
        }
      },
    );
  }
}
