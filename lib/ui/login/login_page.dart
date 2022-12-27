import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/login_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'components/login_text_form_field.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 600,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 인트로
                    _buildIntroText(),
                    const SizedBox(height: 50),
                    // 로그인 폼
                    _buildLoginForm(context),
                    const SizedBox(height: 20),
                    // 회원찾기 & 회원가입 버튼 모음
                    _buildFindJoinButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'TABLE ',
            style: TextStyle(fontSize: 40, color: Colors.black),
            children: [
              TextSpan(
                text: 'NOW',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Text('안녕하세요.', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'TABLE NOW ',
            style: TextStyle(fontSize: 20, color: Colors.black),
            children: [
              TextSpan(
                text: '매장용',
                style: TextStyle(color: primaryColor),
              ),
              TextSpan(text: '입니다.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(context) {
    return Column(
      children: [
        // 아이디
        LoginTextFormField(
          hint: '아이디',
          controller: controller.username,
        ),
        const SizedBox(height: 10),
        // 비밀번호
        LoginTextFormField(
          hint: '비밀번호',
          controller: controller.password,
        ),
        const SizedBox(height: 10),
        // 로그인 버튼
        Obx(
          () => controller.loaded.value
              ? StateRoundButton(
                  text: '로그인',
                  activated: controller.activated.value,
                  tapFunc: () async {
                    int result = await controller.login();
                    if (result == 200) {
                      // 1. 로그인 성공
                      // 로그아웃 하지 않는 이상 로그인 페이지로의 이동 막음
                      Get.offAllNamed(Routes.main);
                    } else if (result == 400) {
                      // 2. 로그인 실패 (유효성검사 실패 포함)
                      showToast(context, '아이디 또는 비밀번호가 일치하지 않습니다.', null);
                    } else if (result == 500) {
                      // 3. 네트워크 연결 안됨
                      showNetworkDisconnectedToast(context);
                    }
                  })
              : const LoadingRoundButton(),
        ),
      ],
    );
  }

  Widget _buildFindJoinButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 아이디 찾기 버튼
        TextButton(
          child: const Text(
            '아이디 찾기',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          onPressed: () {
            // 텍스트필드 초기화
            controller.initializeTextField();
            // 텍스트필드 포커스 해제
            FocusScope.of(context).unfocus();
            Get.toNamed(Routes.find, arguments: '아이디');
          },
        ),
        Container(
          width: 1,
          height: 15,
          color: blueGrey,
          margin: const EdgeInsets.symmetric(horizontal: 5),
        ),
        // 비밀번호 찾기 버튼
        TextButton(
          child: const Text(
            '비밀번호 찾기',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          onPressed: () {
            // 텍스트필드 초기화
            controller.initializeTextField();
            // 텍스트필드 포커스 해제
            FocusScope.of(context).unfocus();
            Get.toNamed(Routes.find, arguments: '비밀번호');
          },
        ),
        Container(
          width: 1,
          height: 15,
          color: blueGrey,
          margin: const EdgeInsets.symmetric(horizontal: 5),
        ),
        // 회원가입 버튼
        TextButton(
          child: const Text(
            '회원가입',
            style: TextStyle(fontSize: 15, color: primaryColor),
          ),
          onPressed: () {
            // 텍스트필드 초기화
            controller.initializeTextField();
            // 텍스트필드 포커스 해제
            FocusScope.of(context).unfocus();
            // 약관동의 페이지로 이동
            Get.toNamed(Routes.agreement);
          },
        ),
      ],
    );
  }
}
