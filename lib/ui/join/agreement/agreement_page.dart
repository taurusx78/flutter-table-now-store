import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/join_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';

class AgreementPage extends GetView<JoinController> {
  const AgreementPage({Key? key}) : super(key: key);

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
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 인트로
                _buildIntroText(),
                const SizedBox(height: 50),
                // 약관 체크박스 목록
                _buildTermsCheckBoxList(),
                const SizedBox(height: 50),
                // 동의 버튼
                _buildAgreeButton(),
              ],
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
        // 제목
        RichText(
          text: const TextSpan(
            text: 'TABLE',
            style: TextStyle(fontSize: 30, color: Colors.black),
            children: [
              TextSpan(
                text: ' NOW',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Text('환영합니다!', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        const Text('서비스 이용을 위해', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        const Text('아래 약관에 대한 동의가 필요합니다.', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildTermsCheckBoxList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 전체 약관 동의
        Obx(
          () => _buildTermsCheckBox(
            '전체 약관 동의',
            controller.agreed[0].value,
            (bool? value) {
              controller.changeAgreed(0, value!);
            },
          ),
        ),
        const CustomDivider(top: 0, bottom: 0),
        // 이용약관 동의
        Obx(
          () => _buildTermsCheckBox(
            '(필수) 이용약관 동의',
            controller.agreed[1].value,
            (bool? value) {
              controller.changeAgreed(1, value!);
            },
          ),
        ),
        // 이용약관 동의 자세히보기 버튼
        _buildDetailsButton(() {
          Get.toNamed(Routes.termsConditions,
                  arguments: controller.agreed[1].value)!
              .then((value) {
            if (value != null && !controller.agreed[1].value) {
              controller.changeAgreed(1, value);
            }
          });
        }),
        // 개인정보 수집 및 이용 동의
        Obx(
          () => _buildTermsCheckBox(
            '(필수) 개인정보 수집 및 이용 동의',
            controller.agreed[2].value,
            (bool? value) {
              controller.changeAgreed(2, value!);
            },
          ),
        ),
        // 개인정보 수집 및 이용 동의 자세히보기 버튼
        _buildDetailsButton(() {
          Get.toNamed(Routes.privacyPolicy,
                  arguments: controller.agreed[2].value)!
              .then((value) {
            if (value != null && !controller.agreed[2].value) {
              controller.changeAgreed(2, value);
            }
          });
        }),
      ],
    );
  }

  Widget _buildTermsCheckBox(String title, bool value, dynamic changedFunc) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: title == '전체 약관 동의' ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      value: value,
      onChanged: changedFunc,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: primaryColor,
      checkColor: Colors.white,
    );
  }

  Widget _buildDetailsButton(routeFunc) {
    return Row(
      children: [
        const SizedBox(width: 55),
        InkWell(
          child: const Text(
            '자세히보기',
            style: TextStyle(color: Colors.black54),
          ),
          onTap: routeFunc,
        ),
      ],
    );
  }

  Widget _buildAgreeButton() {
    return Obx(
      () => StateRoundButton(
        text: '동의하고 시작하기',
        activated: controller.agreed[0].value,
        tapFunc: () {
          // 본인인증 완료 여부 초기화
          controller.userCanJoin(false);
          // 본인인증된 사용자 정보 초기화
          controller.setUserInfo('', '', '');
          // 본인인증 페이지로 이동
          Get.toNamed(Routes.auth);
        },
      ),
    );
  }
}
