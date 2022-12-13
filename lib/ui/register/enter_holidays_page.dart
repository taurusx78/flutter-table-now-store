import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/holiday_select_button.dart';
import 'package:table_now_store/ui/components/round_button.dart';

import 'components/register_appbar.dart';
import 'components/step_indicator.dart';

class EnterHolidaysPage extends GetView<HolidaysController> {
  EnterHolidaysPage({Key? key}) : super(key: key);

  final SaveStoreReqDto store = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(title: '정기휴무'),
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
                // 정기휴무 유무
                const HolidaySelectButton(isUpdatePage: false),
                const SizedBox(height: 10),
                // 정기휴무 목록
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildHolidayList(),
                  ),
                ),
                const SizedBox(height: 70),
                // 다음 버튼
                RoundButton(
                  text: '다음',
                  tapFunc: () {
                    controller.setHolidaysInfo(store);
                    Get.toNamed(Routes.enterHours, arguments: store);
                  },
                ),
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
        const StepIndicator(step: 3),
        const SizedBox(height: 20),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '정기휴무',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '가 있는 경우,\n해당 요일을 선택해주세요.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHolidayList() {
    String content = controller.makeHolidayInfoText();

    return !controller.hasHoliday.value
        ? const Text(
            '정기휴무가 없습니다.',
            style: TextStyle(fontSize: 16),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.8,
                ),
              ),
              if (content != '')
                const Text(
                  '정기휴무 입니다.',
                  style: TextStyle(fontSize: 16),
                )
            ],
          );
  }
}
