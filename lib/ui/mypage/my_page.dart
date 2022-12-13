import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/main_controller.dart';
import 'package:table_now_store/controller/user/login_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/two_round_buttons.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'components/app_info_button.dart';

class MyPage extends StatelessWidget {
  MyPage({Key? key}) : super(key: key);

  final MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내정보'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              children: [
                // 프로필
                _buildProfileBox(),
                const SizedBox(height: 10),
                // 내정보관리 & 로그아웃 버튼
                TwoRoundButtons(
                  leftText: '내정보 관리',
                  leftTapFunc: () {
                    Get.toNamed(Routes.profile);
                  },
                  rightText: '로그아웃',
                  rightTapFunc: () {
                    _showDialog(context);
                  },
                  padding: 40,
                ),
                const SizedBox(height: 50),
                // 고객 안내 버튼 모음
                _buildGuideButtons(),
                const SizedBox(height: 40),
                // 앱정보 버튼 모음
                _buildAppInfoButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle_rounded,
                color: blueGrey,
                size: 60,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름
                  SizedBox(
                    width: 200,
                    child: Text(
                      controller.name.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // 아이디
                  SizedBox(
                    width: 200,
                    child: Text(
                      controller.username.value,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const CustomDivider(top: 15, bottom: 15),
          // 휴대폰번호
          Obx(
            () => _buildInfoText('휴대폰번호', controller.phone.value),
          ),
          const CustomDivider(top: 15, bottom: 15),
          // 이메일
          Obx(
            () => _buildInfoText('이메일', controller.email.value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String title, String content) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: SizedBox(
              width: 95,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TextSpan(
            text: content.replaceAll('', '\u{200B}'),
            style: const TextStyle(fontSize: 17, color: Colors.black),
          )
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1, // 한 줄 말줄임
    );
  }

  Widget _buildGuideButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 공지사항
        _buildGuideItem('assets/images/notice.png', '공지사항', () {
          Get.toNamed(Routes.appNotice);
        }),
        const SizedBox(width: 20),
        // 이용방법
        _buildGuideItem('assets/images/help.png', '이용방법', () {
          Get.toNamed(Routes.help);
        }),
        const SizedBox(width: 20),
        // 고객센터
        _buildGuideItem('assets/images/customer_service.png', '고객센터', () {
          Get.toNamed(Routes.customerService);
        }),
      ],
    );
  }

  Widget _buildGuideItem(String path, String label, dynamic tapFunc) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Image.asset(path, width: 60),
            const SizedBox(height: 10),
            Text(label),
          ],
        ),
      ),
      onTap: tapFunc,
    );
  }

  Widget _buildAppInfoButtons() {
    return Column(
      children: [
        // 약관 및 정책
        AppInfoButton(
          title: '약관 및 정책',
          icon: Icons.assignment_outlined,
          routeFunc: () {
            Get.toNamed(Routes.policy);
          },
        ),
        // 기타 정보
        AppInfoButton(
          title: '기타 정보',
          icon: Icons.more_horiz,
          routeFunc: () {
            Get.toNamed(Routes.extra);
          },
        ),
        // 현재버전
        AppInfoButton(
          title: '현재버전',
          icon: Icons.check_circle_outline_rounded,
          routeFunc: () {
            // *** 앱스토어로 연결
          },
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
          title: '로그아웃 하시겠습니까?',
          checkFunc: () {
            Navigator.pop(context2);
            Get.put(LoginController()).logout();
            Get.offAllNamed(Routes.login);
          },
        );
      },
    );
  }
}
