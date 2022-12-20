import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/user/find_id_resp_dto.dart';
import 'package:table_now_store/controller/user/find_controller.dart';
import 'package:table_now_store/controller/user/timer_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/auth_number_guide_text.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/loading_round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/validator_util.dart';

class FindIdPage extends GetView<FindController> {
  FindIdPage({Key? key}) : super(key: key);

  final String method = Get.arguments; // 인증 방법 (이메일 또는 휴대폰번호)

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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    method == 'email'
                        ? '회원정보에 등록한 이메일을 입력해 주세요.'
                        : '회원정보에 등록한 휴대폰번호를 입력해 주세요.',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  // 이메일 또는 휴대폰번호 폼
                  _buildDataForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이메일 또는 휴대폰번호
        Form(
          key: controller.dataFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Obx(
            () => method == 'email'
                ? CustomTextFormField(
                    hint: '이메일을 입력해 주세요.',
                    controller: controller.data,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    counterText: '',
                    enabled: !controller.clicked.value,
                    validator: validateEmail(),
                  )
                : CustomTextFormField(
                    hint: '- 제외한 휴대폰 번호',
                    controller: controller.data,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    counterText: '',
                    enabled: !controller.clicked.value,
                    validator: validateUserPhone(),
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
                    // 인증번호 요청
                    controller.sendAuthNumber().then((result) {
                      if (result == 1) {
                        // 유효시간 5분 카운터 시작
                        Get.put(TimerController()).startTimer();
                        showToast(context, '인증번호가 발송되었습니다.', null);
                        // 인증번호 텍스트필트 포커스 주기
                        controller.authNumberFocusNode.requestFocus();
                      } else if (result == -1) {
                        showToast(
                          context,
                          '인증번호 발송에 실패하였습니다.\n입력한 정보를 다시 확인해 주세요.',
                          3000,
                        );
                      } else if (result == -3) {
                        showNetworkDisconnectedToast(context);
                      }
                    });
                  },
                )
              : controller.sent.value
                  ? _buildAuthForm(context)
                  : const LoadingRoundButton(),
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
        StateRoundButton(
          text: '인증 완료',
          activated: _timerController.duration.value != 0 &&
              controller.filled[2].value,
          tapFunc: () {
            _showProcessingDialog(context);
          },
        ),
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
                    controller.clearAuthTextField();
                    // 인증번호 요청
                    controller.sendAuthNumber().then((result) {
                      if (result == 1) {
                        // 유효시간 5분 카운터 시작
                        _timerController.startTimer();
                        showToast(context, '인증번호가 발송되었습니다.', null);
                        // 인증번호 텍스트필트 포커스 주기
                        controller.authNumberFocusNode.requestFocus();
                      } else if (result == -1) {
                        showToast(
                          context,
                          '인증번호 발송에 실패하였습니다.\n입력한 정보를 다시 확인해 주세요.',
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

  void _showProcessingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context2) {
        controller.findId(method).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result.runtimeType == FindIdRespDto || result == 0) {
            // 1. 인증 성공 (회원 존재 FindIdRespDto, 회원 없음 0)
            // FindId 페이지 제거
            Navigator.pop(context);
            // Find 페이지 제거 및 FindIdResult 페이지로 이동
            Get.offNamed(Routes.findIdResult, arguments: [method, result]);
          } else if (result == -1) {
            // 2. 인증 or 유효성검사 실패
            showToast(context, '인증번호를 다시 확인해주세요.', null);
            // 인증번호 텍스트필트 포커스 주기
            controller.authNumberFocusNode.requestFocus();
          } else if (result == -3) {
            // 3. 네트워크 연결 안됨
            showNetworkDisconnectedToast(context);
          }
        });

        return const LoadingContainer(text: '조회중');
      },
    );
  }
}
