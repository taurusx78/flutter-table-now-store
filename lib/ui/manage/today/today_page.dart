import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/controller/store/manage_controller.dart';
import 'package:table_now_store/controller/store/update_today_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/network_disconnected_text.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/store_state_text.dart';
import 'package:table_now_store/ui/custom_color.dart';

class TodayPage extends GetView<ManageController> {
  final int storeId;

  TodayPage({Key? key, required this.storeId}) : super(key: key);

  List<String> holiday = ['', '영업일', '정기휴무', '임시휴무', '임시휴무'];
  var today;

  @override
  Widget build(BuildContext context) {
    print('오늘의 영업시간 빌드');

    return Obx(() {
      if (controller.loaded.value) {
        today = controller.today.value;
        if (today != null) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                width: 600,
                margin: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: Column(
                  children: [
                    // 오늘 날짜 & 영업상태
                    _buildTodayStateText(),
                    const SizedBox(height: 30),
                    const CustomDivider(),
                    // 영업시간
                    _buildHoursBox(),
                    const CustomDivider(),
                    const SizedBox(height: 30),
                    // 오늘의 영업시간 변경 버튼
                    _buildChangeTodayButton(context),
                    const SizedBox(height: 30),
                    // 전체 영업시간 변경 안내 문구
                    _buildChangeHoursGuide(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return NetworkDisconnectedText(
            retryFunc: () {
              // 오늘의 영업시간 조회 (비동기 실행)
              controller.findToday(storeId);
            },
          );
        }
      } else {
        return const LoadingIndicator();
      }
    });
  }

  Widget _buildTodayStateText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 오늘 날짜
        Text(
          DateFormat('M월 d일 E요일', 'ko_kr').format(DateTime.now()),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        // 영업상태
        StoreStateText(state: today.state),
      ],
    );
  }

  Widget _buildHoursBox() {
    if (today.holidayType == 1) {
      // 1. 영업일인 경우
      return Column(
        children: [
          // 영업시간
          _buildHoursText('영업시간', today.businessHours),
          const CustomDivider(),
          // 휴게시간
          _buildHoursText('휴게시간', today.breakTime),
          const CustomDivider(),
          // 주문마감시간
          _buildHoursText('주문마감시간', today.lastOrder),
        ],
      );
    } else {
      // 2. 휴무일인 경우
      return Text(
        '오늘은 ${holiday[today.holidayType]}입니다.',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      );
    }
  }

  Widget _buildHoursText(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeTodayButton(context) {
    return RoundButton(
      text: '오늘의 영업시간 변경',
      tapFunc: () async {
        // 1. 오늘의 영업시간 다시조회 (데이터 동기화)
        await controller.findToday(storeId);
        if (controller.today.value != null) {
          // 2. 페이지 이동 전 데이터 세팅
          Get.put(UpdateTodayController()).initializeTodayData(today);
          // 3. 오늘의 영업시간 변경 페이지로 이동
          Get.toNamed(Routes.changeToday, arguments: [storeId, today])!
              .then((result) {
            // 뒤로가기 시 null 리턴
            if (result != null) {
              if (result.runtimeType == Today) {
                // 수정된 오늘의 영업시간 반영
                controller.changeToday(result);
                showToast(context, '오늘의 영업시간이 변경되었습니다.', null);
              } else if (result == 417) {
                // 정기휴무 -> 임시휴무 영업상태 변경 반영
                controller.changeToday(Today(
                  holidayType: 3,
                  businessHours: '없음',
                  breakTime: '없음',
                  lastOrder: '없음',
                  state: '임시휴무',
                ));
                showToast(
                  context,
                  '영업시간 변경에 실패하였습니다.\n오늘 임시휴무가 설정된 알림을 수정 또는 삭제해 주세요.',
                  3500,
                );
              }
            }
          });
        }
      },
    );
  }

  Widget _buildChangeHoursGuide(context) {
    return RichText(
      text: TextSpan(
        text: 'ⓘ 전체 영업시간이 변동된 경우, ',
        style: const TextStyle(fontSize: 15, color: Colors.black54),
        children: [
          WidgetSpan(
            child: InkWell(
              child: const Text(
                '영업시간 설정',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async {
                // 전체 영업시간 조회 및 초기화 (비동기 실행)
                Get.put(HoursController()).findHours(storeId);
                Get.toNamed(Routes.hoursInfo, arguments: storeId)!
                    .then((result) {
                  // 수정 성공 (Today), 뒤로가기 (null)
                  if (result != null && result.runtimeType == Today) {
                    // 수정된 오늘의 영업시간 반영
                    controller.changeToday(result);
                    showToast(context, '영업시간을 수정하였습니다.', null);
                  }
                });
              },
            ),
          ),
          const TextSpan(
            text: '에서 정보를 변경해 주세요.',
          ),
        ],
      ),
    );
  }
}
