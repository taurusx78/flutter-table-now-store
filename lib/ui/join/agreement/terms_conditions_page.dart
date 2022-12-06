import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/ui/join/components/agree_button.dart';

class TermsConditionsPage extends StatelessWidget {
  TermsConditionsPage({Key? key}) : super(key: key);

  bool agreed = Get.arguments; // 동의 여부

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('이용약관'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('이용약관 웹 페이지 불러오기' * 50),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: AgreeButton(
          activated: agreed,
          tapFunc: () {
            agreed = true;
            Get.back(result: agreed);
          },
        ),
      ),
    );
  }
}
