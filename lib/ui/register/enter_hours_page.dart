import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/save_store_req_dto.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/controller/store/save_store_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/hours_list.dart';
import 'package:table_now_store/ui/components/info_row_text.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';

import 'components/register_appbar.dart';
import 'components/step_indicator.dart';

class EnterHoursPage extends GetView<HoursController> {
  EnterHoursPage({Key? key}) : super(key: key);

  final SaveStoreReqDto store = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(title: '영업시간'),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 안내 문구
                _buildGuideText(),
                const SizedBox(height: 50),
                // 초기화 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh, color: primaryColor, size: 20),
                        Text(
                          ' 전체 초기화',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.initializeHours(null);
                    },
                  ),
                ),
                // 영업시간 목록
                const HoursList(),
                const SizedBox(height: 50),
                // 매장등록 버튼
                RoundButton(
                  text: '매장등록하기',
                  tapFunc: () {
                    _showDialog(context);
                  },
                )
              ],
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
        // 페이지 인덱스
        const StepIndicator(step: 4),
        const SizedBox(height: 20),
        // 안내 문구
        RichText(
          text: const TextSpan(
            text: '영업시간',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '을 설정해주세요.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const InfoRowText(
          text: '휴무일로 지정된 날짜는 설정된 영업시간이 적용되지 않습니다.',
          margin: 40,
          iconColor: red,
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
          title: '매장을 등록 하시겠습니까?',
          content: '입력한 정보는 등록 이후에도 수정이 가능합니다.',
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
        // 매장 등록 진행
        Get.put(SaveStoreController())
            .save(controller.setHoursInfo(store))
            .then((result) {
          Navigator.pop(context);
          if (result == 200) {
            Get.offAllNamed(Routes.main); // 매장 등록 후 메인페이지로 이동
            showToast(context, '매장이 등록되었습니다.', null);
          } else if (result == 403) {
            Get.offAllNamed(Routes.login);
            Get.snackbar('알림', '권한이 없는 사용자입니다.\n다시 로그인해 주세요.');
          } else if (result == 500) {
            showNetworkDisconnectedToast(context);
          } else {
            showErrorToast(context);
          }
        });

        return const LoadingContainer(text: '등록중');
      },
    );
  }
}
