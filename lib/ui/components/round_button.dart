import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final dynamic tapFunc;

  const RoundButton({
    Key? key,
    required this.text,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: primaryColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }
}
