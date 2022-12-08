import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final dynamic tapFunc;

  const CustomDialogButton({
    Key? key,
    required this.text,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: text == '확인' ? primaryColor : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: text == '확인' ? Colors.white : primaryColor,
              ),
            ),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }
}
