import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class StoreStateText extends StatelessWidget {
  final String state;
  String iconImage = 'stop';
  Color color = Colors.black38;

  StoreStateText({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 색상 지정: 영업중 (초록), 휴게시간 (파랑), 휴무 (빨강), 주문마감 & 준비중 (검정)
    if (state == '영업중') {
      color = green;
      iconImage = 'play';
    } else if (state == '휴게시간') {
      color = primaryColor;
      iconImage = 'pause';
    } else if (state.contains('휴무')) {
      color = red;
    }

    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 10, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icons/$iconImage.png',
              width: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              state,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
