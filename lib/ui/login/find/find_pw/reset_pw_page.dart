import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/change_pw_controller.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/util/validator_util.dart';

class ResetPwPage extends GetView<ChangePwController> {
  ResetPwPage({Key? key}) : super(key: key);

  final String username = Get.arguments[0];
  final String authNumber = Get.arguments[1];

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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호 재설정',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 안내 문구
                  RichText(
                    text: const TextSpan(
                      text: '비밀번호는 ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '영문, 숫자, 특수문자를 모두 포함해 8~20자',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '로 설정해 주세요.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 비밀번호 재설정 폼
                  _buildResetPwForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPwForm(context) {
    return Column(
      children: [
        // 새 비밀번호
        Form(
          key: controller.newPwFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '새 비밀번호',
            controller: controller.newPassword,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validateNewPassword(null),
          ),
        ),
        const SizedBox(height: 15),
        // 새 비밀번호 확인
        Form(
          key: controller.newPwCheckFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '새 비밀번호 확인',
            controller: controller.newPasswordCheck,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validatePasswordCheck(),
          ),
        ),
        const SizedBox(height: 15),
        // 변경 버튼
        Obx(
          () => StateRoundButton(
            text: '비밀번호 재설정',
            activated: controller.filled[1].value && controller.filled[2].value,
            tapFunc: () async {
              _showDialog(context);
            },
          ),
        ),
      ],
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '비밀번호를 재설정하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            _showProcessingDialog(context);
          },
        );
      },
    );
  }

  void _showProcessingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context2) {
        controller.resetPassword(username, authNumber).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result == 200) {
            Get.back(); // 로그인 페이지로 이동
            showToast(context, '비밀번호가 재설정되었습니다.\n다시 로그인해 주세요.', 3000);
          } else if (result == 500) {
            showNetworkDisconnectedToast(context);
          } else {
            showErrorToast(context);
          }
        });

        return const LoadingContainer(text: '로딩중');
      },
    );
  }
}
