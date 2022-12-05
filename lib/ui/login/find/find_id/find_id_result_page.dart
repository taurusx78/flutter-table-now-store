import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/two_round_buttons.dart';
import 'package:table_now_store/ui/custom_color.dart';

class FindIdResultPage extends StatelessWidget {
  FindIdResultPage({Key? key}) : super(key: key);

  final String method = Get.arguments[0]; // 인증방법
  final dynamic result = Get.arguments[1]; // 아이디찾기 결과 (FindIdRespDto 또는 0)

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
            // 로그인 페이지로 이동
            Get.offAllNamed(Routes.login);
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
                  '아이디 찾기 결과',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                // 결과 정보
                result != 0 ? _buildUserInfoBox() : _buildNoUserBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoBox() {
    return Column(
      children: [
        Image.asset('assets/images/success.png', width: 70),
        const SizedBox(height: 30),
        Text(
          '입력하신 ${method == 'email' ? '이메일' : '휴대폰번호'}로 가입된 회원님의',
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 5),
        const Text(
          '아이디는 아래와 같습니다.',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 30),
        // 아이디
        Text(
          result.username,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkNavy,
          ),
        ),
        const SizedBox(height: 10),
        // 가입일
        Text(
          '가입일 ${result.createdDate}',
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 100),
        // 페이지 이동 버튼
        TwoRoundButtons(
          leftText: '로그인',
          leftTapFunc: () {
            Get.back();
          },
          rightText: '비밀번호 찾기',
          rightTapFunc: () {
            Get.offNamed(Routes.find, arguments: '비밀번호');
          },
          padding: 60,
        ),
      ],
    );
  }

  Widget _buildNoUserBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/fail.png',
          width: 70,
          color: darkNavy,
        ),
        const SizedBox(height: 30),
        Text(
          '입력하신 ${method == 'email' ? '이메일' : '휴대폰번호'}로 가입된 회원이',
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 5),
        const Text(
          '존재하지 않습니다.',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 100),
        // 페이지 이동 버튼
        TwoRoundButtons(
          leftText: '회원가입',
          leftTapFunc: () {
            Get.back();
          },
          rightText: '아이디 다시찾기',
          rightTapFunc: () {
            Get.offNamed(Routes.find, arguments: '아이디');
          },
          padding: 60,
        ),
      ],
    );
  }
}
