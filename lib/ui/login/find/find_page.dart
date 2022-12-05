import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/find_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';

class FindPage extends GetView<FindController> {
  FindPage({Key? key}) : super(key: key);

  final String type = Get.arguments; // 찾을 정보 (아이디 또는 비밀번호)

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
            Get.back();
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type 찾기',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$type 찾기 방법을 선택해 주세요.',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                // 찾기 버튼 모음
                _buildMethodButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButtons() {
    return Column(
      children: [
        _buildMethodButton(1, '이메일', Icons.mail_rounded),
        const SizedBox(height: 15),
        _buildMethodButton(2, '휴대폰번호', Icons.phone_android),
        const SizedBox(height: 15),
        // 인증번호 받기 버튼
        Obx(
          () => StateRoundButton(
            text: '다음',
            activated: controller.method.value != 0,
            tapFunc: () {
              if (type == '아이디') {
                // 1. 아이디 찾기 요청
                if (controller.method.value == 1) {
                  Get.toNamed(Routes.findId, arguments: 'email')!.then((value) {
                    // 뒤로가기 시 전체 상태 초기화
                    controller.initializeAllState();
                  });
                } else {
                  Get.toNamed(Routes.findId, arguments: 'phone')!.then((value) {
                    controller.initializeAllState();
                  });
                }
              } else {
                // 2. 비밀번호 찾기 요청
                if (controller.method.value == 1) {
                  Get.toNamed(Routes.findPw, arguments: 'email')!.then((value) {
                    controller.initializeAllState();
                  });
                } else {
                  Get.toNamed(Routes.findPw, arguments: 'phone')!.then((value) {
                    controller.initializeAllState();
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMethodButton(int index, String method, IconData icon) {
    return Obx(
      () => GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: !(controller.method.value == index)
                  ? lightGrey
                  : primaryColor,
              width: 2,
            ),
            color: lightGrey,
          ),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(icon),
                foregroundColor: !(controller.method.value == index)
                    ? blueGrey
                    : primaryColor,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 15),
              Text(
                '$method 인증하기',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          controller.changeMethod(index);
        },
      ),
    );
  }
}
