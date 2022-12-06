import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class LoadingIndicator extends StatelessWidget {
  final String? text;

  const LoadingIndicator({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2,
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                text!,
                style: const TextStyle(fontSize: 20),
              ),
            )
        ],
      ),
    );
  }
}
