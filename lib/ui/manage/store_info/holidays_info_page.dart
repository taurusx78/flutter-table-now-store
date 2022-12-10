import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/holiday_select_button.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/manage/store_info/components/modified_text.dart';
import 'package:table_now_store/ui/screen_size.dart';

class HolidaysInfoPage extends GetView<HolidaysController> {
  HolidaysInfoPage({Key? key}) : super(key: key);

  final int storeId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('정기휴무 설정'),
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
                            modifiedDate: controller.holidays!.modifiedDate),
                        const SizedBox(height: 50),
                        // 정기휴무 유무
                        HolidaySelectButton(
                          isUpdatePage: true,
                          width: getScreenWidth(context) - 40 < 600
                              ? (getScreenWidth(context) - 40) / 2 - 5
                              : 295,
                        ),
                        const SizedBox(height: 20),
                        // 정기휴무 목록
                        _buildHolidayList(),
                        const SizedBox(height: 70),
                        // 수정 버튼
                        controller.updated.value
                            ? RoundButton(
                                text: '수정',
                                tapFunc: () {
                                  _showDialog(context);
                                },
                              )
                            : const LoadingRoundButton(),
                      ],
                    ),
                  ),
                ),
              )
            : const LoadingIndicator(),
      ),
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

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '정기휴무를 수정하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            // 정기휴무 수정
            dynamic result = await controller.updateHolidays(storeId);
            Get.back(result: result);
          },
        );
      },
    );
  }
}
