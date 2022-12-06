import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

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
            _buildDialogButton(
              '취소',
              () {
                Navigator.pop(context); // alertDialog 닫기
              },
            ),
            const SizedBox(width: 10),
            // 확인 버튼
            _buildDialogButton('확인', checkFunc),
          ],
        )
      ],
    );
  }

  Widget _buildDialogButton(String text, dynamic tapFunc) {
    return Container(
      width: 70,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: text == '확인' ? primaryColor : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: text == '확인' ? Colors.white : primaryColor,
              ),
            ),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }
}
