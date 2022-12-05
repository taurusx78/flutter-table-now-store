import 'package:flutter/material.dart';
import 'package:table_now_store/ui/screen_size.dart';

class ListRowText extends StatelessWidget {
  final String text;
  final double margin;
  final Color? color;

  const ListRowText({
    Key? key,
    required this.text,
    required this.margin,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, right: 5),
          child: Icon(Icons.circle, size: 5, color: Colors.black38),
        ),
        SizedBox(
          width: getScreenWidth(context) - margin < 600
              ? getScreenWidth(context) - margin - 20
              : 580,
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: color ?? Colors.black54),
          ),
        ),
      ],
    );
  }
}
