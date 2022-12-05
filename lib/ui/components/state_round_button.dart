import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class StateRoundButton extends StatelessWidget {
  final String text;
  final bool activated; // 버튼 활성화 여부
  final dynamic tapFunc;

  const StateRoundButton({
    Key? key,
    required this.text,
    required this.activated,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: activated ? primaryColor : blueGrey,
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
          onTap: activated ? tapFunc : null,
        ),
      ),
    );
  }
}
