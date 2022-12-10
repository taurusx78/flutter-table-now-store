import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/info_row_text.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';

class HolidaySwitch extends StatelessWidget {
  HolidaySwitch({Key? key}) : super(key: key);

  final SaveNoticeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 스위치 버튼
        _buildHolidaySwitchButton(),
        const CustomDivider(top: 20, bottom: 0),
        // 날짜 선택 버튼
        Obx(
          () => controller.hasHoliday.value
              ? _buildDatePickerButtons(context)
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildHolidaySwitchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '임시휴무 설정하기',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Obx(
          () => SizedBox(
            width: 40,
            height: 25,
            child: Switch(
              value: controller.hasHoliday.value,
              activeColor: primaryColor,
              onChanged: (value) {
                controller.changeHasHoliday(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerButtons(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            // 시작일
            _buildDatePickerButton(
              context,
              0,
              controller.holidayStartDate.value,
            ),
            const Text(' ~ '),
            // 종료일
            _buildDatePickerButton(
              context,
              1,
              controller.holidayEndDate.value,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const InfoRowText(
          text: '임시휴무가 설정된 알림은 휴무 종료 시 알림이 자동 삭제됩니다.',
          margin: 40,
        ),
        const CustomDivider(top: 15, bottom: 0),
      ],
    );
  }

  // type: 시작일 (0), 종료일 (1)
  Widget _buildDatePickerButton(context, int type, String text) {
    return InkWell(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: blueGrey),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.event_note, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 5),
              Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showDatePicker(context, type);
        // 텍스트필드 포커스 해제
        FocusScope.of(context).unfocus();
      },
    );
  }

  // type: 시작일 (0), 종료일 (1)
  void _showDatePicker(context, int type) {
    showDatePicker(
      context: context,
      initialDate: type == 0
          ? controller.holidayStartDate.value == '시작일'
              ? DateTime.now()
              : DateTime.parse(controller.holidayStartDate.value)
          : controller.holidayEndDate.value == '종료일'
              ? DateTime.now()
              : DateTime.parse(controller.holidayEndDate.value),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // 헤더 배경 색상
              onPrimary: Colors.white, // 헤더 문구 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: primaryColor, // 하단 버튼 색상
              ),
            ),
            // 테두리 둥글게
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((dateTime) {
      // 날짜 선택 후 실행됨
      if (dateTime != null) {
        String result = controller.selectDate(type, dateTime);
        if (result != '') {
          showToast(context, result, 1500);
        }
      }
    });
  }
}
