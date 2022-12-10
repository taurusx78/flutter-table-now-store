import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class ModifiedText extends StatelessWidget {
  final String modifiedDate;

  const ModifiedText({Key? key, required this.modifiedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: primaryColor,
          size: 18,
        ),
        Text(
          ' 최종수정일 : $modifiedDate',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
