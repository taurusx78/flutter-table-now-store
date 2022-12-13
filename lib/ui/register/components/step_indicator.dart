import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class StepIndicator extends StatelessWidget {
  final int step;

  const StepIndicator({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Icon(
            Icons.circle,
            size: index != step ? 12 : 15,
            color: index == step ? primaryColor : blueGrey,
          ),
        );
      }).toList(),
    );
  }
}
