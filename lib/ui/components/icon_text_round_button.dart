import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class IconTextRoundButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final dynamic tapFunc;

  const IconTextRoundButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: blueGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 5),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      onTap: tapFunc,
    );
  }
}
