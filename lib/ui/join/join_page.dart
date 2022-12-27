import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/join_controller.dart';
import 'package:table_now_store/controller/user/timer_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/info_row_text.dart';
import 'package:table_now_store/ui/components/list_row_text.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/validator_util.dart';

class JoinPage extends GetView<JoinController> {
  JoinPage({Key? key}) : super(key: key);

  double textFieldWidth = Get.arguments; // 텍스트필드 너비

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
          title: const Text('회원가입'),
          actions: [
            IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.login);
              },
            ),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더
                  const Text(
                    '회원정보',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 인증된 사용자 정보
                  _buildUserInfoBox(),
                  const SizedBox(height: 40),
                  // 회원가입 폼
                  _buildJoinForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름
          _buildUserInfoText('이름', controller.name.value),
          const SizedBox(height: 20),
          // 휴대폰 번호
          _buildUserInfoText(
            '휴대폰번호',
            controller.phone.value.replaceAllMapped(
              RegExp(r'(\d{3})(\d{3,4})(\d{4})'),
              (m) => '${m[1]}-${m[2]}-${m[3]}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoText(String title, String content) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 1,
          height: 15,
          color: blueGrey,
          margin: const EdgeInsets.symmetric(horizontal: 15),
        ),
        Text(content, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildJoinForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 아이디
        _buildUsernameTextField(context),
        const SizedBox(height: 40),
        // 비밀번호
        _buildPasswordTextField(),
        const SizedBox(height: 40),
        // 이메일
        _buildEmailTextField(context),
        const SizedBox(height: 50),
        // 회원가입 버튼
        RoundButton(
          text: '회원가입',
          tapFunc: () {
            if (controller.usernameState.value == 0) {
              if (controller.emailVerified.value) {
                // 비밀번호 유효성 검사
                if (controller.pwFormKey.currentState!.validate() &&
                    controller.pwCheckFormKey.currentState!.validate()) {
                  _showDialog(context);
                }
              } else {
                showToast(context, '이메일 인증을 완료해 주세요.', null);
              }
            } else {
              showToast(context, '아이디 중복확인을 완료해 주세요.', null);
            }
          },
        ),
      ],
    );
  }

  Widget _buildUsernameTextField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 아이디 헤더
        const Text(
          '아이디',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이디 텍스트필드
              Form(
                key: controller.usernameFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextFormField(
                  width: textFieldWidth,
                  hint: '영어 소문자, 숫자 (4~20자)',
                  controller: controller.username,
                  maxLength: 20,
                  counterText: '',
                  enabled: controller.usernameState.value != 0,
                  validator: validateUsername(),
                ),
              ),
              const SizedBox(width: 5),
              // 아이디 중복확인 버튼
              controller.usernameState.value != 0
                  ? _buildCheckButton('중복확인', () {
                      // 아이디 유효성 검사
                      if (controller.usernameFormKey.currentState!.validate()) {
                        // 아이디 중복확인
                        controller.checkUsername().then((result) {
                          if (result == 500) {
                            showNetworkDisconnectedToast(context);
                          } else if (result > 1) {
                            showErrorToast(context);
                          }
                        });
                        // 텍스트필드 포커스 해제 (다른 텍스트필드로의 포커스 이동 방지)
                        FocusScope.of(context).unfocus();
                      }
                    })
                  : _buildCheckButton('다시입력', () {
                      // 아이디 중복확인 여부 초기화
                      controller.initializeUsernameState();
                      // 텍스트필드 포커스 해제 (다른 텍스트필드로의 포커스 이동 방지)
                      FocusScope.of(context).unfocus();
                    }),
            ],
          ),
        ),
        // 중복확인 결과 안내 문구
        Obx(
          () => controller.usernameState.value != -1
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5),
                  child: controller.usernameState.value == 0
                      ? const Text(
                          '사용할 수 있는 아이디입니다.',
                          style: TextStyle(fontSize: 14, color: primaryColor),
                        )
                      : const Text(
                          '이미 사용중인 아이디입니다.',
                          style: TextStyle(fontSize: 14, color: red),
                        ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildCheckButton(text, tapFunc) {
    return SizedBox(
      width: 80,
      height: 55,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: lightGrey,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          child: Center(
            child: Text(text),
          ),
          onTap: tapFunc,
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 비밀번호 헤더
        const Text(
          '비밀번호',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // 비밀번호 텍스트필드
        Form(
          key: controller.pwFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '영문, 숫자, 특수문자 모두 포함 (8~20자)',
            controller: controller.password,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validateNewPassword(null),
          ),
        ),
        const SizedBox(height: 10),
        // 비밀번호 확인 텍스트필드
        Form(
          key: controller.pwCheckFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '비밀번호 확인',
            controller: controller.passwordCheck,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validateJoinPasswordCheck(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTextField(context) {
    final TimerController _timerController = Get.put(TimerController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이메일 헤더
        const Text(
          '이메일',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이메일 텍스트필드
              Form(
                key: controller.emailFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextFormField(
                  width: textFieldWidth,
                  hint: '이메일을 입력해주세요.',
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  counterText: '',
                  enabled: !controller.emailClicked.value,
                  validator: validateEmail(),
                ),
              ),
              const SizedBox(width: 5),
              // 인증 관련 버튼
              !controller.emailClicked.value
                  ? _buildCheckButton('인증하기', () {
                      // 이메일 유효성 검사
                      if (controller.emailFormKey.currentState!.validate()) {
                        // 이메일 인증번호 요청
                        controller.sendAuthNumber().then((result) {
                          if (result == 200) {
                            controller.changeEmailClicked();
                            // 유효시간 5분 카운터 시작
                            _timerController.startTimer();
                            showToast(context, '입력한 메일로 인증번호가 발송되었습니다.', null);
                            // 인증번호 텍스트필드 포커스 부여
                            controller.authNumberFocusNode.requestFocus();
                          } else if (result == 500) {
                            showNetworkDisconnectedToast(context);
                          } else {
                            showErrorToast(context);
                          }
                        });
                      }
                    })
                  : _buildCheckButton('다시입력', () {
                      // 이메일 인증여부 초기화
                      controller.initializeEmailAuth();
                      // 타이머 종료
                      _timerController.endTimer();
                      // 텍스트필드 포커스 해제 (다른 텍스트필드로의 포커스 이동 방지)
                      FocusScope.of(context).unfocus();
                    }),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 인증 안내 문구
        Obx(
          () => !controller.emailClicked.value
              ? const InfoRowText(
                  text: '이메일은 아이디/비밀번호 찾기, 매장정보 수정제안 등의 메일 전송을 위해 사용됩니다.',
                  margin: 40,
                )
              : !controller.emailVerified.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAuthNumberTextField(context, _timerController),
                        const SizedBox(height: 10),
                        _timerController.duration.value != 0
                            ? Column(
                                children: const [
                                  ListRowText(
                                    text: '인증완료 버튼을 눌러 인증을 완료해 주세요.',
                                    margin: 40,
                                    color: darkNavy,
                                  ),
                                  SizedBox(height: 5),
                                  ListRowText(
                                    text:
                                        '인증번호 전송은 최대 1분까지 소요될 수 있습니다. 잠시만 기다려주세요.',
                                    margin: 40,
                                  ),
                                ],
                              )
                            : Column(
                                children: const [
                                  ListRowText(
                                    text: '인증 유효시간이 만료되었습니다.',
                                    margin: 40,
                                  ),
                                  SizedBox(height: 5),
                                  ListRowText(
                                    text: '인증번호를 다시 받으려면 인증번호 재전송 버튼을 눌러주세요.',
                                    margin: 40,
                                    color: darkNavy,
                                  ),
                                ],
                              ),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Text(
                        '이메일 인증이 완료되었습니다.',
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ),
        )
      ],
    );
  }

  Widget _buildAuthNumberTextField(context, timerController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 인증번호 텍스트필드
            Form(
              key: controller.authNumberFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomTextFormField(
                width: textFieldWidth,
                hint: '인증번호 입력',
                controller: controller.authNumber,
                focusNode: controller.authNumberFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                counterText: '',
                validator: validateAuthNumber(),
              ),
            ),
            const SizedBox(width: 5),
            // 인증 관련 버튼
            _buildCheckButton('인증완료', () {
              if (controller.authNumberFormKey.currentState!.validate()) {
                // 텍스트필드 포커스 해제
                FocusScope.of(context).unfocus();
                // 이메일 인증번호 검증
                controller.verityEmail().then((result) {
                  if (result == 200) {
                    controller.changeEmailVerified();
                  } else if (result == 401) {
                    showToast(context, '인증번호가 일치하지 않습니다.', null);
                  } else if (result == 500) {
                    showNetworkDisconnectedToast(context);
                  } else {
                    showErrorToast(context);
                  }
                });
              }
            })
          ],
        ),
        const SizedBox(height: 10),
        // 타이머
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: timerController.duration.value != 0
              ? RichText(
                  text: TextSpan(
                    text: '남은시간  ',
                    style: const TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text:
                            '${timerController.minutes}:${timerController.seconds}',
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
                      if (result == 200) {
                        // 유효시간 5분 카운터 시작
                        timerController.startTimer();
                        showToast(context, '입력한 메일로 인증번호가 발송되었습니다.', null);
                        // 인증번호 텍스트필드 포커스 부여
                        controller.authNumberFocusNode.requestFocus();
                      } else if (result == 500) {
                        showNetworkDisconnectedToast(context);
                      } else {
                        showErrorToast(context);
                      }
                    });
                  },
                ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '회원가입을 완료 하시겠습니까?',
          checkFunc: () {
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
        // 회원가입 진행
        controller.join().then((result) {
          if (result == 200) {
            // 가입 성공 (가입 성공 페이지로 이동)
            Get.offAllNamed(Routes.joinSuccess);
          } else if (result == 500) {
            showNetworkDisconnectedToast(context);
          } else {
            showErrorToast(context);
          }
        });

        return const LoadingContainer(text: '가입중');
      },
    );
  }
}
