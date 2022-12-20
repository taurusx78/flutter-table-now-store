import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/holiday_select_button.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/manage/store_info/components/modified_text.dart';

class HolidaysInfoPage extends GetView<HolidaysController> {
  HolidaysInfoPage({Key? key}) : super(key: key);

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
        title: const Text('정기휴무 설정'),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.loaded.value) {
          if (controller.holidays != null) {
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
                          modifiedDate: controller.holidays!.modifiedDate),
                      const SizedBox(height: 50),
                      // 정기휴무 유무
                      const HolidaySelectButton(isUpdatePage: true),
                      const SizedBox(height: 20),
                      // 정기휴무 목록
                      _buildHolidayList(),
                      const SizedBox(height: 70),
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
            return const Center(
              child: Text('네트워크 연결을 확인해 주세요.'),
            );
          }
        } else {
          return const LoadingIndicator();
        }
      }),
    );
  }

  Widget _buildHolidayList() {
    String content = controller.makeHolidayInfoText();

    return !controller.hasHoliday.value
        ? const Text(
            '정기휴무가 없습니다.',
            style: TextStyle(fontSize: 16),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.8,
                ),
              ),
              if (content != '')
                const Text(
                  '정기휴무 입니다.',
                  style: TextStyle(fontSize: 16),
                )
            ],
          );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '정기휴무를 수정하시겠습니까?',
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
        // 정기휴무 수정 진행
        controller.updateHolidays(storeId).then((result) {
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
