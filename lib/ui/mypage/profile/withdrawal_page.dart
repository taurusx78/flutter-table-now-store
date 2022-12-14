import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/withdrawal_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';
import 'package:table_now_store/util/validator_util.dart';

class WithdrawalPage extends GetView<WithdrawalController> {
  const WithdrawalPage({Key? key}) : super(key: key);

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
                children: [
                  // 탈퇴 안내 문구
                  _buildGuideText(),
                  const CustomDivider(top: 30, bottom: 30),
                  // 탈퇴 사유
                  _buildReasonsBox(context),
                  const CustomDivider(top: 30, bottom: 30),
                  // 비밀번호 확인 폼
                  _buildPwCheckForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '회원탈퇴 안내',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // *** 탈퇴 안내 문구 작성
        Text('회원 탈퇴 안내 문구 작성' * 50),
      ],
    );
  }

  Widget _buildReasonsBox(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '탈퇴 사유',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
            '저희 서비스를 이용하시면서 불편했던 점을 알려주세요. 고객님의 의견을 듣고 서비스 개선을 위해 노력하겠습니다.'),
        const SizedBox(height: 20),
        // 탈퇴 사유 선택 버튼
        _buildReasonsButton(context),
      ],
    );
  }

  Widget _buildReasonsButton(context) {
    return GestureDetector(
      child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: blueGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => controller.selectedReason.value == ''
                    ? const Text(
                        '탈퇴 사유를 알려주세요.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      )
                    : Text(
                        controller.selectedReason.value,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: primaryColor,
              ),
            ],
          )),
      onTap: () {
        _showReasonsDialog(context);
      },
    );
  }

  void _showReasonsDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: const Text(
            '탈퇴 사유',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: getScreenWidth(context) * 0.8,
            height: getScreenHeight(context) * 0.5,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: blueGrey),
                bottom: BorderSide(color: blueGrey),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.reasons.length,
              itemBuilder: (context, index) {
                String reason = controller.reasons[index];
                return Obx(
                  () => RadioListTile(
                    title: Text(reason),
                    value: reason,
                    activeColor: primaryColor,
                    groupValue: controller.selectedReason.value,
                    onChanged: (value) {
                      controller.changeSelectedReason(reason);
                    },
                  ),
                );
              },
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 15),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    '선택',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // alertDialog 닫기
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildPwCheckForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '탈퇴 처리',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '탈퇴를 원하시는 경우, 아래에 계정 비밀번호를 입력 후 ',
            style: TextStyle(fontSize: 15, color: Colors.black),
            children: [
              TextSpan(
                text: '탈퇴하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              TextSpan(
                text: ' 버튼을 눌러주세요.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 비밀번호 텍스트필드
        Form(
          key: controller.pwFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '비밀번호를 입력해주세요.',
            controller: controller.password,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validateCurPassword(),
          ),
        ),
        const SizedBox(height: 50),
        // 탈퇴하기 버튼
        Obx(
          () => StateRoundButton(
            text: '탈퇴하기',
            activated: controller.filled.value,
            tapFunc: () {
              if (controller.selectedReason.value != '') {
                _showDialog(context);
              } else {
                showToast(context, '탈퇴 사유를 선택해 주세요.', null);
              }
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
          title: '정말로 탈퇴하시겠습니까?',
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
        controller.withdrawal().then((name) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (name != null) {
            // 1. 탈퇴 성공 (회원 이름)
            Get.snackbar('알림', '$name님, 회원탈퇴가 완료되었습니다.\n그동안 이용해주셔서 감사합니다.');
            Get.offAllNamed(Routes.login);
          } else {
            // 2. 탈퇴 실패 (null)
            showToast(context, '비밀번호가 일치하지 않습니다.', null);
          }
        });

        return const LoadingContainer(text: '탈퇴중');
      },
    );
  }
}
