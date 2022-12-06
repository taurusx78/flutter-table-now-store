import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/round_button.dart';

class JoinSuccessPage extends StatelessWidget {
  const JoinSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Image.asset('assets/images/welcome.png', width: 120),
                  const SizedBox(height: 50),
                  const Text(
                    '가입을 축하합니다!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '지금 매장을 등록하고',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '매장의 최신 정보를 제공해보세요!',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  // 시작 버튼
                  RoundButton(
                    text: '시작하기',
                    tapFunc: () {
                      // 로그인 페이지로 이동
                      Get.offAllNamed(Routes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
