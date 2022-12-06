import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';

class InfoRowText extends StatelessWidget {
  final String text;
  final double margin;
  final Color? iconColor;

  const InfoRowText({
    Key? key,
    required this.text,
    required this.margin,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 5),
          child: Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: iconColor ?? primaryColor,
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
