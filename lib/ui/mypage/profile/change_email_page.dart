import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/change_email_controller.dart';
import 'package:table_now_store/controller/user/timer_controller.dart';
import 'package:table_now_store/ui/components/auth_number_guide_text.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/validator_util.dart';

class ChangeEmailPage extends GetView<ChangeEmailController> {
  ChangeEmailPage({Key? key}) : super(key: key);

  final TimerController _timerController = Get.put(TimerController());

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
                  const Text(
                    '이메일 변경',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 안내 문구
                  const Text(
                    '이메일은 아이디/비밀번호 찾기, 매장정보 수정요청 등의 메일 전송에 사용됩니다.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  // 이메일 폼
                  _buildEmailForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이메일
        Form(
          key: controller.emailFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Obx(
            () => CustomTextFormField(
              hint: '새 이메일을 입력해주세요.',
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              counterText: '',
              enabled: !controller.clicked.value,
              validator: validateEmail(),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // 인증번호 받기 버튼
        Obx(
          () => !controller.clicked.value
              ? StateRoundButton(
                  text: '인증번호 받기',
                  activated: controller.filled[0].value,
                  tapFunc: () {
                    controller.changeClicked(true);
                    // 이메일 인증번호 요청
                    controller.sendAuthNumber().then((result) {
                      if (result == 1) {
                        // 유효시간 5분 카운터 시작
                        _timerController.startTimer();
                        showToast(context, '입력한 메일로 인증번호가 발송되었습니다.', null);
                        // 인증번호 텍스트필드 포커스 주기
                        controller.authNumberFocusNode.requestFocus();
                      } else if (result == -1) {
                        showToast(
                          context,
                          '인증번호 발송에 실패하였습니다.\n입력한 메일을 다시 확인해 주세요.',
                          3000,
                        );
                      } else if (result == -3) {
                        showNetworkDisconnectedToast(context);
                      }
                    });
                  },
                )
              : _buildAuthForm(context),
        ),
      ],
    );
  }

  Widget _buildAuthForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 인증번호
        _buildAuthNumberTextField(context),
        const SizedBox(height: 30),
        // 안내 문구
        AuthNumberGuideText(),
        const SizedBox(height: 50),
        // 인증 완료 버튼
        _buildCompleteButton(context),
      ],
    );
  }

  Widget _buildAuthNumberTextField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: controller.authNumberFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '인증번호 입력',
            controller: controller.authNumber,
            focusNode: controller.authNumberFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            counterText: '',
            enabled: _timerController.duration.value > 0,
            validator: validateAuthNumber(),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: _timerController.duration.value != 0
              ? RichText(
                  text: TextSpan(
                    text: '남은시간  ',
                    style: const TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text:
                            '${_timerController.minutes}:${_timerController.seconds}',
                        style: const TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  child: const Text(
                    '인증번호 재전송',
                    style: TextStyle(color: primaryColor),
                  ),
                  onTap: () {
                    // 인증번호 텍스트필드 초기화
                    controller.initializeAuthTextField();
                    // 이메일 인증번호 요청
                    controller.sendAuthNumber().then((result) {
                      if (result == 1) {
                        // 유효시간 5분 카운터 시작
                        _timerController.startTimer();
                        showToast(context, '입력한 메일로 인증번호가 발송되었습니다.', null);
                        // 인증번호 텍스트필드 포커스 주기
                        controller.authNumberFocusNode.requestFocus();
                      } else if (result == -1) {
                        showToast(
                          context,
                          '인증번호 발송에 실패하였습니다.\n입력한 메일을 다시 확인해 주세요.',
                          3000,
                        );
                      } else if (result == -3) {
                        showNetworkDisconnectedToast(context);
                      }
                    });
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCompleteButton(context) {
    return StateRoundButton(
      text: '이메일 변경',
      activated:
          _timerController.duration.value != 0 && controller.filled[1].value,
      tapFunc: () async {
        showDialog(
          context: context,
          barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
          barrierColor: Colors.transparent,
          builder: (BuildContext context2) {
            controller.verifyEmail().then((result) {
              // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
              Navigator.pop(context);
              if (result == 1) {
                _showDialog(context);
              } else if (result == -1) {
                showToast(context, '인증번호가 일치하지 않습니다.', null);
              } else if (result == -3) {
                showNetworkDisconnectedToast(context);
              }
            });

            return const LoadingContainer(text: '인증중');
          },
        );
      },
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '이메일을 변경하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            showDialog(
              context: context,
              barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
              barrierColor: Colors.transparent,
              builder: (BuildContext context2) {
                controller.changeEmail().then((result) {
                  // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
                  Navigator.pop(context);
                  if (result == 1) {
                    showToast(context, '이메일이 변경되었습니다.', null);
                    Get.back(result: controller.email.text);
                  } else if (result == -1) {
                    showToast(
                      context,
                      '이메일 변경에 실패하였습니다.\n입력한 이메일을 다시 확인해 주세요.',
                      3000,
                    );
                  } else if (result == -3) {
                    showNetworkDisconnectedToast(context);
                  }
                });

                return const LoadingContainer(text: '변경중');
              },
            );
          },
        );
      },
    );
  }
}
