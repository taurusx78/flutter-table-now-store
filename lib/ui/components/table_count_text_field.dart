import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/inside_controller.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';

import 'list_row_text.dart';

class TableCountTextField extends StatelessWidget {
  TableCountTextField({Key? key}) : super(key: key);

  final InsideController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '전체테이블 수',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const ListRowText(
          text: '0~500 범위의 숫자',
          margin: 40,
        ),
        const SizedBox(height: 10),
        _buildCountTextField(context),
      ],
    );
  }

  Widget _buildCountTextField(context) {
    return Row(
      children: [
        // 감소 버튼
        _buildOperationButton(Icons.remove_rounded, () {
          int result = controller.changeAllTableCount(true);
          if (result == -1) {
            showToast(context, '숫자만 입력 가능합니다.', null);
          }
        }),
        const SizedBox(width: 5),
        // 전체테이블 수 텍스트필드
        SizedBox(
          width: getScreenWidth(context) - 40 < 600
              ? getScreenWidth(context) - 150
              : 450,
          height: 50,
          child: TextFormField(
            controller: controller.allTableCount,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            maxLength: 3,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: blueGrey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        // 감소 버튼
        _buildOperationButton(Icons.add_rounded, () {
          int result = controller.changeAllTableCount(false);
          if (result == -1) {
            showToast(context, '숫자만 입력 가능합니다.', null);
          }
        }),
      ],
    );
  }

  Widget _buildOperationButton(IconData icon, tapFunc) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Material(
        color: lightGrey,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }
}
