import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/notice/save_notice_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/add_image_button.dart';
import 'package:table_now_store/ui/components/list_row_text.dart';
import 'package:table_now_store/ui/components/round_image.dart';
import 'package:table_now_store/ui/custom_color.dart';

class NoticeImageUploader extends StatelessWidget {
  NoticeImageUploader({Key? key}) : super(key: key);

  final SaveNoticeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: const [
            Text(
              '사진',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '  * 선택',
              style: TextStyle(fontSize: 14, color: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const ListRowText(text: '최대 2장, 한 장당 5MB 이하', margin: 40),
        const SizedBox(height: 10),
        // 이미지 추가 버튼
        AddImageButton(tapFunc: () {
          controller.selectImages();
          // 알림 제목 & 내용 텍스트필드 포커스 해제
          FocusScope.of(context).unfocus();
        }),
        // 업로드한 이미지 목록
        Obx(
          () => controller.noticeImageList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _buildImageList(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 120, // 높이 지정 필수!
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.noticeImageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: RoundImage(
              type: 'notice',
              image: controller.noticeImageList[index],
              deleteFunc: () {
                controller.deleteNoticeImage(index);
              },
            ),
            onTap: () {
              Get.toNamed(
                Routes.image,
                arguments: ['notice', controller.noticeImageList, index],
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
