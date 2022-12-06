import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class StoreStateText extends StatelessWidget {
  final String state;
  Color color = Colors.black38;

  StoreStateText({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 색상 지정: 영업중 (초록), 휴게시간 (파랑), 휴무 (빨강), 주문마감 & 준비중 (검정)
    if (state == '영업중') {
      color = green;
    } else if (state == '휴게시간') {
      color = primaryColor;
    } else if (state.contains('휴무')) {
      color = red;
    }

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Center(
        child: Text(
          state,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
