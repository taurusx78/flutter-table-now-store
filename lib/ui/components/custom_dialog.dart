import 'package:flutter/material.dart';

import 'custom_dialog_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? content;
  final dynamic checkFunc;

  const CustomDialog({
    Key? key,
    required this.title,
    this.content,
    this.checkFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: content == null
            ? Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      content: content != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                child: Text(content!),
              ),
            )
          : null,
      actionsPadding: const EdgeInsets.only(bottom: 20),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 취소 버튼
            CustomDialogButton(
              text: '취소',
              tapFunc: () {
                Navigator.pop(context); // alertDialog 닫기
              },
            ),
            const SizedBox(width: 10),
            // 확인 버튼
            CustomDialogButton(
              text: '확인',
              tapFunc: checkFunc,
            ),
          ],
        )
      ],
    );
  }
}
