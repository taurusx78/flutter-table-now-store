import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/menu_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/image_uploader.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/network_disconnected_text.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/manage/store_info/components/modified_text.dart';

class MenuInfoPage extends GetView<MenuController> {
  MenuInfoPage({Key? key}) : super(key: key);

  final int storeId = Get.arguments;

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
        title: const Text('메뉴 관리'),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.loaded.value) {
          if (controller.menu != null) {
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Container(
                  width: 600,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 최종수정일
                      ModifiedText(modifiedDate: controller.menu!.modifiedDate),
                      const SizedBox(height: 50),
                      _buildMenuInfoBox(context),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return NetworkDisconnectedText(
              retryFunc: () {
                // 메뉴 조회 및 초기화 (비동기 실행)
                controller.findMenu(storeId);
              },
            );
          }
        } else {
          return const LoadingIndicator();
        }
      }),
    );
  }

  Widget _buildMenuInfoBox(context) {
    return Column(
      children: [
        // 메뉴 사진
        ImageUploader(
          type: 'menu',
          title: '메뉴사진',
          guideText: '최대 20장, 한 장당 5MB 이하',
          controller: controller,
        ),
        const SizedBox(height: 70),
        // 수정 버튼
        RoundButton(
          text: '수정',
          tapFunc: () {
            if (controller.imageList.isNotEmpty) {
              if (controller.imageList.length > 20) {
                showToast(context, '메뉴사진을 20장 이하로 올려주세요.', null);
              } else {
                _showDialog(context);
              }
            } else {
              showToast(context, '메뉴사진을 최소 1장 올려주세요.', null);
            }
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
          title: '메뉴를 수정하시겠습니까?',
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
        // 메뉴 수정 진행
        controller.updateMenu(storeId).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result == 200) {
            showToast(context, '메뉴를 수정하였습니다.', null);
            Get.back(result: 1);
          } else if (result == 403) {
            Get.offAllNamed(Routes.login);
            Get.snackbar('알림', '권한이 없는 사용자입니다.\n다시 로그인해 주세요.');
          } else if (result == 500) {
            showNetworkDisconnectedToast(context);
          } else {
            showErrorToast(context);
          }
        });

        return const LoadingContainer(text: '수정중');
      },
    );
  }
}
