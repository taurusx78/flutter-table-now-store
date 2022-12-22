import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: 2,
      ),
    );
  }
}
