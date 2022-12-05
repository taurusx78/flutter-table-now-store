import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';

class TwoRoundButtons extends StatelessWidget {
  final String leftText;
  final dynamic leftTapFunc;
  final String rightText;
  final dynamic rightTapFunc;
  final double padding;

  const TwoRoundButtons({
    Key? key,
    required this.leftText,
    required this.leftTapFunc,
    required this.rightText,
    required this.rightTapFunc,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = getScreenWidth(context) - padding < 600
        ? (getScreenWidth(context) - padding) / 2 - 5
        : 295;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: Material(
            borderRadius: BorderRadius.circular(5),
            color: blueGrey,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              child: Center(
                child: Text(
                  leftText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkNavy,
                  ),
                ),
              ),
              onTap: leftTapFunc,
            ),
          ),
        ),
        SizedBox(
          width: width,
          height: 50,
          child: Material(
            borderRadius: BorderRadius.circular(5),
            color: primaryColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              child: Center(
                child: Text(
                  rightText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: rightTapFunc,
            ),
          ),
        ),
      ],
    );
  }
}
