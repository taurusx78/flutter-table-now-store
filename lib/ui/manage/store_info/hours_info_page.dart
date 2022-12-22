import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/hours_list.dart';
import 'package:table_now_store/ui/components/info_row_text.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/network_disconnected_text.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'components/modified_text.dart';

class HoursInfoPage extends GetView<HoursController> {
  HoursInfoPage({Key? key}) : super(key: key);

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
        title: const Text('영업시간 설정'),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.loaded.value) {
          if (controller.hours != null) {
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
                      ModifiedText(
                          modifiedDate: '${controller.hours!.modifiedDate}'),
                      const SizedBox(height: 10),
                      // 안내 문구
                      const InfoRowText(
                        text: '휴무일로 지정된 날짜는 설정된 영업시간이 적용되지 않습니다.',
                        margin: 40,
                        iconColor: red,
                      ),
                      const SizedBox(height: 50),
                      // 영업시간 목록
                      const HoursList(),
                      const SizedBox(height: 50),
                      // 수정 버튼
                      RoundButton(
                        text: '수정',
                        tapFunc: () {
                          _showDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return NetworkDisconnectedText(
              retryFunc: () {
                // 영업시간 조회 및 초기화 (비동기 실행)
                controller.findHours(storeId);
              },
            );
          }
        } else {
          return const LoadingIndicator();
        }
      }),
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '영업시간을 수정하시겠습니까?',
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
        // 영업시간 수정 진행
        controller.updateHours(storeId).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result.runtimeType == Today) {
            Get.back(result: result);
          } else if (result == -1) {
            showToast(context, '입력한 정보를 다시 확인해 주세요.', null);
          } else if (result == -2) {
            showToast(context, '권한이 없는 사용자입니다.', null);
          } else if (result == -3) {
            showNetworkDisconnectedToast(context);
          }
        });

        return const LoadingContainer(text: '수정중');
      },
    );
  }
}
