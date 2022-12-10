import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/hours_list.dart';
import 'package:table_now_store/ui/components/info_row_text.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'components/modified_text.dart';

class HoursInfoPage extends GetView<HoursController> {
  HoursInfoPage({Key? key}) : super(key: key);

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
        title: const Text('영업시간 설정'),
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
                            modifiedDate: '${controller.hours!.modifiedDate}'),
                        const SizedBox(height: 10),
                        // 안내 문구
                        const InfoRowText(
                          text: '휴무일로 지정된 날짜는 설정된 영업시간이 적용되지 않습니다.',
                          margin: 40,
                          iconColor: red,
                        ),
                        const SizedBox(height: 50),
                        // 영업시간 목록
                        const HoursList(),
                        const SizedBox(height: 50),
                        // 수정 버튼
                        Obx(
                          () => controller.updated.value
                              ? RoundButton(
                                  text: '수정',
                                  tapFunc: () {
                                    _showDialog(context);
                                  },
                                )
                              : const LoadingRoundButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const LoadingIndicator(),
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '영업시간을 수정하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            // 영업시간 수정
            dynamic result = await controller.updateHours(storeId);
            Get.back(result: result);
          },
        );
      },
    );
  }
}
