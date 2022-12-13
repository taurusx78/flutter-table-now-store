import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/main_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/custom_color.dart';

class ProfilePage extends GetView<MainController> {
  const ProfilePage({Key? key}) : super(key: key);

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
        title: const Text('내정보 관리'),
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
                const Icon(
                  Icons.account_circle_rounded,
                  color: blueGrey,
                  size: 70,
                ),
                const SizedBox(height: 20),
                // 이름
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 아이디
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 30),
                  child: Text(
                    controller.username.value,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: primaryColor,
                ),
                // 비밀번호
                _buildInfoAndButton(Icons.lock_outline, '비밀번호', null, () {
                  Get.toNamed(Routes.changePw);
                }),
                // 휴대폰번호
                Obx(
                  () => _buildInfoAndButton(
                      Icons.phone_android, '휴대폰번호', controller.phone.value, () {
                    Get.toNamed(Routes.changePhone);
                  }),
                ),
                // 이메일
                Obx(
                  () => _buildInfoAndButton(
                      Icons.email_outlined, '이메일', controller.email.value, () {
                    Get.toNamed(Routes.changeEmail)!.then((value) {
                      if (value != null) {
                        controller.changeEmail(value);
                      }
                    });
                  }),
                ),
                const SizedBox(height: 20),
                // 회원탈퇴
                _buildWithdrawalButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoAndButton(
      IconData icon, String title, String? content, dynamic routeFunc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: title != '이메일'
              ? const BorderSide(color: blueGrey)
              : const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 제목
              Row(
                children: [
                  Icon(icon, color: Colors.black54, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 수정 버튼
              _buildUpdateButton(routeFunc),
            ],
          ),
          // 내용
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 13),
              child: Text(
                content,
                style: const TextStyle(fontSize: 17),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(dynamic routeFunc) {
    return Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: const Center(
          child: Text(
            '변경',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        onTap: routeFunc,
      ),
    );
  }

  Widget _buildWithdrawalButton() {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '회원탈퇴',
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black54,
              size: 18,
            ),
          ),
        ],
      ),
      onTap: () {
        Get.toNamed(Routes.withdrawal);
      },
    );
  }
}
