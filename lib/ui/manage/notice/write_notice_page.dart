import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';
import 'package:table_now_store/ui/components/custom_text_area.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/util/validator_util.dart';

import 'components/holiday_switch.dart';
import 'components/notice_dialog.dart';
import 'components/notice_image_uploader.dart';

class WriteNoticePage extends GetView<SaveNoticeController> {
  WriteNoticePage({Key? key}) : super(key: key);

  int storeId = Get.arguments;

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
          title: const Text('알림 등록'),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 안내 문구
                  _buildGuideText(),
                  const SizedBox(height: 70),
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

  Widget _buildGuideText() {
    return RichText(
      text: const TextSpan(
        text: '임시휴무 안내, 이벤트',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: ' 등\n고객들에게 전할 ',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: '매장 알림',
          ),
          TextSpan(
            text: '을\n등록해 보세요.',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
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
        // 등록 버튼
        Obx(
          () => controller.completed.value
              ? RoundButton(
                  text: '등록',
                  tapFunc: () {
                    if (controller.titleFormKey.currentState!.validate() &&
                        controller.contentFormKey.currentState!.validate()) {
                      _showDialog(context);
                    }
                  },
                )
              : const LoadingRoundButton(),
        ),
      ],
    );
  }

  void _showDialog(context) {
    // 임시휴무 정보 확인
    String holiday = controller.getHolidayInfo();

    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return NoticeDialog(
          title: '알림을 등록하시겠습니까?',
          noticeTitle: controller.title.text,
          holiday: holiday,
          tapFunc: () async {
            Navigator.pop(context2);
            // 알림 등록 성공 (1), 실패 (-1)
            int result = await controller.save(storeId);
            Get.back(result: result);
          },
        );
      },
    );
  }
}
