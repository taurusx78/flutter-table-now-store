import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/find_controller.dart';

class FindPwPage extends GetView<FindController> {
  FindPwPage({Key? key}) : super(key: key);

  final String method = Get.arguments; // 인증 방법 (이메일 또는 휴대폰번호)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    method == 'email' ? '이메일 인증' : '휴대폰번호 인증',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 안내 문구
                  Text(
                    method == 'email'
                        ? '회원정보에 등록한 아이디와 이메일을 입력해 주세요.'
                        : '회원정보에 등록한 아이디와 휴대폰번호를 입력해 주세요.',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  // 아이디 / 이메일 또는 휴대폰번호 폼
                  // _buildIdDataForm(context),
                  // // 인증번호 폼
                  // Obx(
                  //   () => controller.isClicked.value
                  //       ? _buildAuthForm(context)
                  //       : const SizedBox(),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
