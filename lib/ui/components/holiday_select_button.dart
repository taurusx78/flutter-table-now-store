import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/custom_color.dart';

class HolidaySelectButton extends GetView<HolidaysController> {
  final bool isUpdatePage; // 정기휴무 수정 페이지인지
  final double width; // 토클 버튼 너비

  const HolidaySelectButton({
    Key? key,
    required this.isUpdatePage,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정기휴무 유무
        _buildHolidaySwitch(),
        const CustomDivider(),
        // 정기휴무 주차 및 요일
        Obx(
          () => controller.hasHoliday.value
              ? _buildHolidayToggleButton(context)
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildHolidaySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '정기휴무 있음',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 40,
          height: 25,
          child: Obx(
            () => Switch(
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

  Widget _buildHolidayToggleButton(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 정기휴무 주차 선택
            _buildWeekToggleButton(width),
            // 정기휴무 요일 선택
            _buildDayToggleButton(width),
          ],
        ),
        const CustomDivider(),
      ],
    );
  }

  Widget _buildWeekToggleButton(width) {
    return ToggleButtons(
      constraints: BoxConstraints(
        minWidth: width,
        minHeight: 50,
      ),
      direction: Axis.vertical,
      fillColor: Colors.white,
      selectedColor: primaryColor,
      selectedBorderColor: primaryColor,
      children: List<Widget>.generate(
        controller.weeks.length,
        (index) => Text(
          controller.weeks[index],
          style: const TextStyle(fontSize: 16),
        ),
      ).toList(),
      isSelected: controller.isHolidayWeek,
      onPressed: (index) {
        controller.toggleIsHolidayWeek(index);
      },
    );
  }

  Widget _buildDayToggleButton(width) {
    return ToggleButtons(
      constraints: BoxConstraints(
        minWidth: width,
        minHeight: 50,
      ),
      direction: Axis.vertical,
      fillColor: Colors.white,
      selectedColor: primaryColor,
      selectedBorderColor: primaryColor,
      children: List<Widget>.generate(
        controller.days.length,
        (index) => Text(
          controller.days[index],
          style: const TextStyle(fontSize: 16),
        ),
      ).toList(),
      isSelected: controller.isHolidayDay,
      onPressed: (index) {
        controller.toggleIsHolidayDay(index);
      },
    );
  }
}
