import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';

class WarningRowText extends StatelessWidget {
  final String text;
  final double margin;

  const WarningRowText({
    Key? key,
    required this.text,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3, right: 5),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: red,
          ),
        ),
        SizedBox(
          width: getScreenWidth(context) - margin < 600
              ? getScreenWidth(context) - margin - 25
              : 575,
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: darkNavy),
          ),
        ),
      ],
    );
  }
}
