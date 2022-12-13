import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_now_store/util/host.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final String type = Get.arguments[0]; // 이미지 유형 (대표사진, 내부사진, 메뉴사진, 알림사진)
  final List<dynamic> imageUrlList = Get.arguments[1]; // 이미지 URL 리스트
  int curIndex = Get.arguments[2]; // 현재 선택된 이미지 인덱스
  late int totalCount; // 전체 이미지 개수

  @override
  void initState() {
    super.initState();
    totalCount = imageUrlList.length;
  }

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
        title: Text('${curIndex + 1} / $totalCount'),
      ),
      body: Swiper(
        itemCount: totalCount,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: imageUrlList[index].runtimeType != XFile
                ? Image.network(
                    '$host/image?type=$type&filename=${imageUrlList[index]}',
                    fit: BoxFit.fitWidth,
                  )
                : Image.file(File(imageUrlList[index].path)),
            maxScale: 3,
          );
        },
        index: curIndex,
        onIndexChanged: (index) {
          setState(() {
            curIndex = index;
          });
        },
        loop: false,
        // 화살표로 이미지 전환
        control: const SwiperControl(
          iconPrevious: Icons.arrow_back_ios_new_rounded,
          iconNext: Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
        // 스크롤을 통한 이미지 전환 방지
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
