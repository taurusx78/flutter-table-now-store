import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/icon_text_round_button.dart';
import 'package:table_now_store/ui/components/round_button.dart';

class RegisterIntroPage extends StatelessWidget {
  const RegisterIntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // 인트로
                  _buildIntroText(),
                  const SizedBox(height: 50),
                  // 매장 등록 버튼
                  RoundButton(
                    text: '신규 매장 등록하기',
                    tapFunc: () {
                      // Get.toNamed(Routes.checkRegistered);
                    },
                  ),
                  const SizedBox(height: 30),
                  // 매장 등록기준 버튼
                  IconTextRoundButton(
                    icon: Icons.policy_outlined,
                    text: '매장등록기준',
                    tapFunc: () {
                      // Get.toNamed(Routes.criteria);
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

  Widget _buildIntroText() {
    return Column(
      children: [
        Image.asset('assets/images/add_store.png', width: 140),
        const SizedBox(height: 50),
        const Text(
          '신규 매장 등록',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          '매장을 등록하고 고객에게',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        const Text(
          '매장의 최신 정보를 알려보세요!',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
  }
}
