import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/timer_controller.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'list_row_text.dart';

class AuthNumberGuideText extends StatelessWidget {
  AuthNumberGuideText({Key? key}) : super(key: key);

  final TimerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.duration.value != 0
          ? const ListRowText(
              text: '인증번호 전송은 최대 1분까지 소요될 수 있습니다. 잠시만 기다려주세요.',
              margin: 40,
            )
          : Column(
              children: const [
                ListRowText(
                  text: '인증 유효시간이 만료되었습니다.',
                  margin: 40,
                ),
                SizedBox(height: 5),
                ListRowText(
                  text: '인증번호를 다시 받으려면 인증번호 재전송 버튼을 눌러주세요.',
                  color: darkNavy,
                  margin: 40,
                ),
              ],
            ),
    );
  }
}
