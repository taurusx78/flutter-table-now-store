import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class LoadingRoundButton extends StatelessWidget {
  const LoadingRoundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: primaryColor,
      ),
      child: const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
