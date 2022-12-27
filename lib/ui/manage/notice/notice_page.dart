import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/notice_controller.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/icon_text_round_button.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/network_disconnected_text.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/screen_size.dart';
import 'package:table_now_store/util/host.dart';

class NoticePage extends StatelessWidget {
  final int storeId;

  NoticePage({Key? key, required this.storeId}) : super(key: key);

  late NoticeController controller;

  @override
  Widget build(BuildContext context) {
    // 알림 전체조회
    print('알림 페이지 빌드');
    controller = Get.put(NoticeController(storeId));

    return Obx(
      () => controller.loaded.value
          ? controller.connected.value
              ? Container(
                  color: lightGrey2,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 헤더
                          Text(
                            '총 ${controller.noticeList.length}개',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // 안내 문구
                          const Text(
                            'ⓘ 매장 알림은 최대 5개까지 등록 가능합니다.',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                          const SizedBox(height: 15),
                          // 알림 목록
                          controller.noticeList.isNotEmpty
                              ? _buildNoticeList()
                              : _buildNoNoticeBox(),
                          const SizedBox(height: 30),
                          // 알림등록 버튼
                          _buildRegisterButton(context),
                        ],
                      ),
                    ),
                  ),
                )
              : NetworkDisconnectedText(
                  retryFunc: () {
                    // 알림 전체조회 (비동기 호출)
                    controller.findAll(storeId);
                  },
                )
          : const LoadingIndicator(),
    );
  }

  Widget _buildNoticeList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.noticeList.length,
      itemBuilder: (context, index) {
        var notice = controller.noticeList[index];
        // 임시휴무 유무
        bool hasHoliday = notice.holidayStartDate != '';

        return GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blueGrey),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: lightGrey,
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // 첨부사진이 있는 경우
                if (notice.imageUrlList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        '$host/image?type=notice&filename=' +
                            notice.imageUrlList[0],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  width: notice.imageUrlList.isNotEmpty
                      ? getScreenWidth(context) - 152
                      : getScreenWidth(context) - 52,
                  height: 85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // 알림 라벨
                          _buildLabelText('알림'),
                          // 휴무 라벨
                          if (hasHoliday)
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: _buildLabelText('휴무'),
                            ),
                          const SizedBox(width: 8),
                          // 등록일
                          Text(
                            '${notice.createdDate} 등록',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 제목
                      Text(
                        notice.title.replaceAll('', '\u{200B}'), // 말줄임 에러 방지
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: !hasHoliday ? 2 : 1,
                      ),
                      // 휴무 알림인 경우
                      if (hasHoliday)
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: _buildHolidayText(
                              notice.holidayStartDate, notice.holidayEndDate),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            // 알림 수정 페이지 데이터 초기화
            Get.put(SaveNoticeController()).initializeUpdateNoticePage(notice);
            Get.toNamed(Routes.updateNotice, arguments: [storeId, notice])!
                .then((result) {
              // 뒤로가기 시 null 리턴
              if (result != null) {
                if (result[1] == 200) {
                  showToast(context, '알림이 ${result[0]}되었습니다.', null);
                } else if (result[1] == 404) {
                  showToast(context, '이미 삭제된 알림입니다.', null);
                }
                // 알림 전체 다시 조회
                controller.findAll(storeId);
              }
            });
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 15),
    );
  }

  Widget _buildLabelText(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: title == '알림'
            ? primaryColor.withOpacity(0.15)
            : red.withOpacity(0.15),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: title == '알림' ? primaryColor : red,
        ),
      ),
    );
  }

  Widget _buildHolidayText(String holidayStart, String holidayEnd) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, color: darkNavy2),
        children: [
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.event_note,
                color: darkNavy2,
                size: 18,
              ),
            ),
          ),
          TextSpan(
            text: '${holidayStart.substring(2)} - ${holidayEnd.substring(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' 휴무')
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1, // 한 줄 말줄임
    );
  }

  Widget _buildNoNoticeBox() {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: blueGrey),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: lightGrey,
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '등록된 알림이 없습니다.',
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(context) {
    return Align(
      alignment: Alignment.center,
      child: IconTextRoundButton(
        icon: Icons.notifications_none_rounded,
        text: '알림등록하기',
        tapFunc: () {
          // 알림 등록 페이지 데이터 초기화
          Get.put(SaveNoticeController()).initializeSaveNoticePage();
          Get.toNamed(Routes.writeNotice, arguments: storeId)!.then((result) {
            // 뒤로가기 시 null 리턴
            if (result != null) {
              showToast(context, '알림이 등록되었습니다.', null);
              // 알림 전체 다시 조회
              controller.findAll(storeId);
            }
          });
        },
      ),
    );
  }
}
