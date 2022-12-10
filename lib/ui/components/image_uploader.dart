import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/round_image.dart';

import 'add_image_button.dart';
import 'custom_divider.dart';
import 'list_row_text.dart';

class ImageUploader extends StatelessWidget {
  final String type; // 사진 유형 (대표사진, 매장내부사진, 메뉴사진, 알림사진)
  final String title;
  final String guideText;
  final dynamic controller;

  const ImageUploader({
    Key? key,
    required this.type,
    required this.title,
    required this.guideText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ListRowText(text: guideText, margin: 40),
        const SizedBox(height: 10),
        // 이미지 추가 버튼
        AddImageButton(tapFunc: () {
          controller.selectImages();
          // 텍스트필드 포커스 해제
          FocusScope.of(context).unfocus();
        }),
        // 업로드한 사진 목록
        Obx(
          () => controller.imageList.isNotEmpty
              ? type == 'basic' || type == 'notice'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _buildImageList(),
                    )
                  : Column(
                      children: [
                        const CustomDivider(),
                        _buildImageGridView(),
                        const CustomDivider(top: 20),
                      ],
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
        itemCount: controller.imageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: RoundImage(
              type: type,
              image: controller.imageList[index],
              deleteFunc: () {
                // 선택된 이미지 삭제
                controller.imageList.removeAt(index);
              },
            ),
            onTap: () {
              Get.toNamed(
                Routes.image,
                arguments: [type, controller.imageList, index],
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }

  Widget _buildImageGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.imageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 행에 보여줄 item 개수
        mainAxisSpacing: 10, // 수직 Padding
        crossAxisSpacing: 10, // 수평 Padding
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: RoundImage(
            width: 200,
            type: type,
            image: controller.imageList[index],
            deleteFunc: () {
              // 선택된 이미지 삭제
              controller.imageList.removeAt(index);
            },
          ),
          onTap: () {
            Get.toNamed(
              Routes.image,
              arguments: [type, controller.imageList, index],
            );
          },
        );
      },
    );
  }
}
