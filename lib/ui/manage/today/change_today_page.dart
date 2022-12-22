import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_now_store/controller/store/update_today_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';

class ChangeTodayPage extends GetView<UpdateTodayController> {
  ChangeTodayPage({Key? key}) : super(key: key);

  final int storeId = Get.arguments[0];
  final Today today = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('오늘의 영업시간 변경'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                // 날짜
                Text(
                  DateFormat('M월 d일 E요일', 'ko_kr').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const CustomDivider(),
                // 휴무 여부
                _buildHoursSwitch('오늘 휴무', 0),
                const CustomDivider(),
                // 영업시간 정보
                Obx(
                  () => !controller.switchState[0].value
                      ? _buildHoursInfoBox(context)
                      : const SizedBox(),
                ),
                const SizedBox(height: 30),
                // 수정 버튼
                RoundButton(
                  text: '변경',
                  tapFunc: () {
                    _showDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // type: 휴무 (0), 24시운영 (1), 휴게시간 (2), 주문마감 (3)
  Widget _buildHoursSwitch(String title, int type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 45,
          height: 25,
          child: Obx(
            () => Switch(
              value: controller.switchState[type].value,
              activeColor: primaryColor,
              onChanged: (value) {
                controller.changeSwitchState(type, value, today);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHoursInfoBox(context) {
    return Column(
      children: [
        // 오픈시간
        _buildTimePicker(context, '오픈시간', 0),
        const SizedBox(height: 25),
        // 마감시간
        _buildTimePicker(context, '마감시간', 1),
        const SizedBox(height: 30),
        // 24시 영업 여부
        _buildHoursSwitch('24시 영업', 1),
        const CustomDivider(),
        // 휴게시간 유무
        _buildHoursSwitch('휴게시간 있음', 2),
        if (controller.switchState[2].value)
          Column(
            children: [
              // 시작시간
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: _buildTimePicker(context, '시작시간', 2),
              ),
              // 종료시간
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: _buildTimePicker(context, '종료시간', 3),
              ),
            ],
          ),
        const CustomDivider(),
        // 주문마감시간 유무
        _buildHoursSwitch('주문마감 설정하기', 3),
        if (controller.switchState[3].value)
          // 주문마감시간
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: _buildTimePicker(context, '주문마감시간', 4),
          ),
        const CustomDivider(),
      ],
    );
  }

  // type: 오픈시간 (0), 마감시간 (1), 휴게시간 시작시간 (2), 종료시간 (3), 주문마감시간 (4)
  Widget _buildTimePicker(context, String title, int type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 40,
          child: OutlinedButton(
            child: Text(
              controller.timeList[type].value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            onPressed: () {
              DatePicker.showTime12hPicker(
                context,
                currentTime: DateTime.now(),
                theme: const DatePickerTheme(
                  cancelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  doneStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                locale: LocaleType.ko,
                onConfirm: (time) {
                  controller.changeTime(type, time);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '영업시간을 변경하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            _showProcessingDialog(context);
          },
        );
      },
    );
  }

  void _showProcessingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context2) {
        // 오늘의 영업시간 수정 진행
        controller.updateToday(storeId).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result.runtimeType == Today || result == 0) {
            Get.back(result: result);
          } else if (result == -1) {
            showToast(context, '입력한 정보를 다시 확인해 주세요.', null);
          } else if (result == -2) {
            showToast(context, '권한이 없는 사용자입니다.', null);
          } else if (result == -3) {
            showNetworkDisconnectedToast(context);
          }
        });

        return const LoadingContainer(text: '변경중');
      },
    );
  }
}
