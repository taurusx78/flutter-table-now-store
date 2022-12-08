import 'package:flutter/material.dart';
import 'package:table_now_store/ui/components/custom_dialog_button.dart';
import 'package:table_now_store/ui/custom_color.dart';

class NoticeDialog extends StatelessWidget {
  final String title;
  final String? noticeTitle;
  final String? holiday;
  final dynamic tapFunc;

  const NoticeDialog({
    Key? key,
    required this.title,
    this.noticeTitle,
    this.holiday,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Align(
          alignment:
              noticeTitle != null ? Alignment.centerLeft : Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      content: noticeTitle != null && holiday != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: blueGrey,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                ),
                // 제목
                Text(
                  noticeTitle!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                // 임시휴무
                _buildHolidayText(holiday!),
                Container(
                  height: 1,
                  color: blueGrey,
                  margin: const EdgeInsets.only(top: 20, bottom: 15),
                ),
              ],
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
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
              tapFunc: tapFunc,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildHolidayText(String holiday) {
    return RichText(
      text: TextSpan(
        children: [
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(Icons.event_note, color: primaryColor, size: 18),
            ),
          ),
          TextSpan(
            text: holiday,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }
}
