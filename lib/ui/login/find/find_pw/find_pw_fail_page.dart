import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/two_round_buttons.dart';
import 'package:table_now_store/ui/custom_color.dart';

class FindPwFailPage extends StatelessWidget {
  FindPwFailPage({Key? key}) : super(key: key);

  final String method = Get.arguments; // 인증방법

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back(); // 로그인 페이지로 이동
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              children: [
                const Text(
                  '비밀번호 찾기 결과',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                // 결과 정보
                _buildNoUserBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoUserBox() {
    return Column(
      children: [
        Image.asset(
          'assets/images/fail.png',
          width: 70,
          color: darkNavy,
        ),
        const SizedBox(height: 30),
        Text(
          '해당 아이디 또는 ${method == 'email' ? '이메일과' : '휴대폰번호와'}',
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 5),
        const Text(
          '일치하는 회원이 존재하지 않습니다.',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 100),
        // 페이지 이동 버튼
        TwoRoundButtons(
          leftText: '아이디 찾기',
          leftTapFunc: () {
            Get.offNamed(Routes.find, arguments: '아이디');
          },
          rightText: '비밀번호 다시찾기',
          rightTapFunc: () {
            Get.offNamed(Routes.find, arguments: '비밀번호');
          },
          padding: 60,
        ),
      ],
    );
  }
}
