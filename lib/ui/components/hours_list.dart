import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/custom_color.dart';

class HoursList extends GetView<HoursController> {
  const HoursList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 요일
            Text(
              controller.days[index],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const CustomDivider(height: 2, top: 15, bottom: 20),
            // 영업시간
            _buildTimePickers(context, '영업시간', 0, index),
            const SizedBox(height: 25),
            // 24시 영업 여부
            _buildHoursSwitch('24시 영업', 0, index),
            const CustomDivider(color: lightGrey),
            // 휴게시간 유무
            _buildHoursSwitch('휴게시간 설정', 1, index),
            // 휴게시간
            Obx(
              () => controller.switchState[1][index]
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: _buildTimePickers(context, '휴게시간', 2, index),
                    )
                  : const SizedBox(),
            ),
            const CustomDivider(color: lightGrey),
            // 주문마감시간 유무
            _buildHoursSwitch('주문마감시간 설정', 2, index),
            // 주문마감시간
            Obx(
              () => controller.switchState[2][index]
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: _buildTimePickers(context, '주문마감시간', 4, index),
                    )
                  : const SizedBox(),
            ),
            const CustomDivider(height: 2, top: 20, bottom: 30),
          ],
        );
      },
    );
  }

  // 오픈시간 (0), 마감시간 (1), 휴게시작시간 (2), 휴게시종료시간 (3), 주문마감시간 (4)
  Widget _buildTimePickers(context, String title, int type, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkNavy,
          ),
        ),
        Row(
          children: [
            _buildTimePicker(context, type, index),
            type != 4
                ? Row(
                    children: [
                      const Text(' - '),
                      _buildTimePicker(context, type + 1, index),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }

  // type: 오픈시간 (0), 마감시간 (1), 휴게시작시간 (2), 휴게종료시간 (3), 주문마감시간 (4)
  Widget _buildTimePicker(context, int type, int index) {
    return Obx(
      () => SizedBox(
        height: 40,
        child: OutlinedButton(
          child: Text(
            controller.timeList[type][index],
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
                controller.changeTime(type, index, time);
              },
            );
          },
        ),
      ),
    );
  }

  // 24시 영업 여부 (0), 휴게시간 유무 (1), 주문마감시간 유무 (2)
  Widget _buildHoursSwitch(String title, int type, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkNavy,
          ),
        ),
        Obx(
          () => SizedBox(
            width: 40,
            height: 25,
            child: Switch(
              value: controller.switchState[type][index],
              activeColor: primaryColor,
              onChanged: (value) {
                controller.changeSwitchState(type, index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
