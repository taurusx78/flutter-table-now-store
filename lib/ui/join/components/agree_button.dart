import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class AgreeButton extends StatelessWidget {
  final bool activated;
  final dynamic tapFunc;

  const AgreeButton({
    Key? key,
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
          child: const Center(
            child: Text(
              '동의',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }
}
