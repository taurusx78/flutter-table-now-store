import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/user/auth_controller.dart';
import 'package:table_now_store/controller/user/join_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';

class AuthPage extends GetView<JoinController> {
  AuthPage({Key? key}) : super(key: key);

  final AuthController _authController = Get.put(AuthController());

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
                const Text(
                  '본인 확인을 위해',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  '휴대폰 인증을 진행해주세요.',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                _buildIamportAuthButton(context),
                const SizedBox(height: 20),
                // 경고 문구
                _buildWarningText(context),
                const SizedBox(height: 50),
                // 다음 버튼
                _buildNextButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIamportAuthButton(context) {
    return Obx(
      () => Material(
        borderRadius: BorderRadius.circular(5),
        color: !controller.canJoin.value ? Colors.white : lightGrey,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: !controller.canJoin.value ? primaryColor : lightGrey,
              ),
            ),
            child: Center(
              child: controller.loaded.value
                  ? Row(
                      children: [
                        Icon(
                          Icons.account_circle_rounded,
                          color: !controller.canJoin.value
                              ? primaryColor
                              : Colors.black54,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        !controller.canJoin.value
                            ? const Text(
                                '휴대폰 본인인증 하기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: darkNavy,
                                ),
                              )
                            : const Text(
                                '휴대폰 본인인증 완료',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              )
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
            ),
          ),
          onTap: !controller.canJoin.value
              ? () async {
                  Map<String, String>? authResult = {'success': 'true'};
                  // Map<String, String>? authResult; // 본인인증 결과 데이터
                  // // 아임포트 본인인증 페이지로 이동
                  // await Get.toNamed(Routes.iamport)!.then((value) {
                  //   if (value != null) {
                  //     authResult = value as Map<String, String>;
                  //   }
                  // });
                  // print('본인인증 결과 (authResult): $authResult');

                  if (authResult != null && authResult['success'] == 'true') {
                    // 1. 인증 토큰 요청
                    // String token = await _authController.getToken();
                    // var userInfo = await _authController.getUserInfo(
                    //     authResult['imp_uid']!, token);
                    // print('인증된 사용자 정보: $userInfo');

                    // 2. 본인인증된 사용자 정보 설정
                    controller.setUserInfo('김태리', '01012345678', '2');

                    // 3. DB에서 unique_key 중복여부 검사
                    int result = await controller.checkJoined();
                    if (result == 1) {
                      // 3-1. 회원 존재
                      showToast(context, '이미 가입한 회원입니다.', 2000);
                    } else if (result == 0) {
                      // 3-2. 가입 가능
                      controller.changeCanJoin(true);
                    } else {
                      // 3-3. 조회 실패
                      showErrorToast(context);
                    }
                  } else {
                    showToast(context, '본인인증에 실패하였습니다.\n다시 시도해주세요.', 2000);
                  }
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildWarningText(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3, right: 5),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: red,
          ),
        ),
        SizedBox(
          width: getScreenWidth(context) - 60 < 600
              ? getScreenWidth(context) - 85
              : 575,
          child: const Text(
            '타인의 개인정보를 도용하여 가입한 경우, 서비스 이용 제한 및 법적 제재를 받으실 수 있습니다.',
            style: TextStyle(fontSize: 15, color: darkNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(context) {
    return Obx(
      () => StateRoundButton(
        text: '다음',
        activated: controller.canJoin.value,
        tapFunc: () async {
          // 회원가입 아이디, 이메일 상태 초기화
          controller.initializeAllState();
          // 다음 페이지의 텍스트필드 너비 설정
          double textFieldWidth = getScreenWidth(context) - 40 < 600
              ? getScreenWidth(context) - 125
              : 515;
          Get.toNamed(Routes.join, arguments: textFieldWidth);
        },
      ),
    );
  }
}
