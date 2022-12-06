import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_now_store/controller/store/manage_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/round_button.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/store_state_text.dart';
import 'package:table_now_store/ui/custom_color.dart';

class TodayPage extends GetView<ManageController> {
  final int storeId;

  TodayPage({Key? key, required this.storeId}) : super(key: key);

  List<String> holiday = ['', '영업일', '정기휴무', '임시휴무', '임시휴무'];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(30, 50, 30, 30),
          child: Obx(() {
            if (controller.loaded.value) {
              var today = controller.today.value!;
              return Column(
                children: [
                  // 오늘 날짜 & 영업상태
                  _buildTodayStateText(today),
                  const SizedBox(height: 30),
                  _buildDivider(),
                  // 영업시간
                  _buildHoursBox(today),
                  _buildDivider(),
                  const SizedBox(height: 30),
                  // 오늘의 영업시간 변경 버튼
                  _buildChangeTodayButton(context, today),
                  const SizedBox(height: 30),
                  // 전체 영업시간 변경 안내 문구
                  _buildChangeHoursGuide(context),
                ],
              );
            } else {
              return const LoadingIndicator();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: blueGrey,
      margin: const EdgeInsets.symmetric(vertical: 20),
    );
  }

  Widget _buildTodayStateText(Today today) {
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

  Widget _buildHoursBox(Today today) {
    if (today.holidayType == 1) {
      // 1. 영업일인 경우
      return Column(
        children: [
          // 영업시간
          _buildHoursText('영업시간', today.businessHours),
          _buildDivider(),
          // 휴게시간
          _buildHoursText('휴게시간', today.breakTime),
          _buildDivider(),
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

  Widget _buildChangeTodayButton(context, Today today) {
    return RoundButton(
      text: '오늘의 영업시간 변경',
      tapFunc: () async {
        // 오늘의 영업시간 다시조회 (데이터 동기화)
        await controller.findToday(storeId);
        Get.toNamed(Routes.changeToday, arguments: [storeId, today])!
            .then((result) async {
          // value: 변경성공 (Today), 변경실패 (-1), 임시휴무 알림 존재 (-2)
          if (result.runtimeType == Today) {
            // 수정된 오늘의 영업시간 반영
            // controller.changeToday(value);
            showToast(context, '오늘의 영업시간이 변경되었습니다.', null);
          } else if (result == -2) {
            // 정기휴무 -> 임시휴무 영업상태 변경 반영
            // controller.changeToday(Today(
            //   holidayType: 3,
            //   businessHours: '없음',
            //   breakTime: '없음',
            //   lastOrder: '없음',
            //   state: '임시휴무',
            // ));
            showToast(context, '변경에 실패하였습니다.\n임시휴무 알림을 수정 또는 삭제해주세요.', 3000);
          } else if (result == -1) {
            showToast(context, '권한이 없는 사용자입니다.', null);
          }
        });
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
                // Get.put(HoursController()).findHours(storeId);
                Get.toNamed(Routes.hoursInfo, arguments: storeId)!
                    .then((today) {
                  if (today != null) {
                    if (today.state != null) {
                      // 수정된 오늘의 영업시간 반영
                      // controller.changeToday(today);
                      showToast(context, '영업시간을 수정하였습니다.', null);
                    } else {
                      showErrorToast(context);
                    }
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
