import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/main_controller.dart';
import 'package:table_now_store/controller/store/manage_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/icon_text_round_button.dart';
import 'package:table_now_store/ui/components/store_state_text.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/host.dart';

class HomePage extends GetView<MainController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 인트로
                  _buildGreetingText(),
                  Container(
                    height: 1.5,
                    color: blueGrey,
                  ),
                  const CustomDivider(height: 1.5, top: 0, bottom: 0),
                  // 나의 매장 목록
                  Obx(
                    () => controller.loaded.value
                        ? controller.myStoreList.isNotEmpty
                            ? _buildMyStoreList(context)
                            : _buildNoStoreBox(context)
                        : const SizedBox(
                            height: 200,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingText() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => controller.userLoaded.value
                ? Text(
                    '${controller.name.value}님',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(width: double.infinity, height: 10),
          const Text(
            '오늘도 힘찬 하루 되세요! \u{1F600}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStoreList(context) {
    return Column(
      children: [
        // 나의 매장 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '나의 매장',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '총 ${controller.myStoreList.length}개',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          height: 450, // 높이 지정 필수!
          margin: const EdgeInsets.only(bottom: 20),
          child: Swiper(
            itemCount: controller.myStoreList.length,
            itemBuilder: (context, index) {
              var store = controller.myStoreList[index];
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          // 대표사진
                          Container(
                            height: 240,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: blueGrey),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.network(
                                '$host/image?type=basic&filename=${store.basicImageUrl}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // 매장 인덱스
                          Positioned(
                            bottom: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                ),
                                color: Colors.black54,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 매장명
                                  Text(
                                    store.name.replaceAll('', '\u{200B}'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1, // 한 줄 말줄임
                                  ),
                                  const SizedBox(height: 10),
                                  // 주소
                                  Text(
                                    store.address.replaceAll('', '\u{200B}') +
                                        ', ' +
                                        store.detailAddress
                                            .replaceAll('', '\u{200B}'),
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2, // 두 줄 말줄임
                                  ),
                                  const SizedBox(height: 10),
                                  // 영업시간
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.black54,
                                        size: 17,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        store.businessHours,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                child: Row(
                                  children: [
                                    // 전화연결 버튼
                                    _buildPhoneConnectButton(),
                                    const SizedBox(width: 10),
                                    // 영업상태
                                    StoreStateText(state: store.state),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  // 1. 매장관리 페이지 이동 전, 데이터 세팅
                  // *** 또는 나의 매장 1개 조회 후 데이터 세팅 ***
                  ManageController _manageController =
                      Get.put(ManageController());
                  _manageController.initializeAllData(
                      store.id, store.name, store.basicImageUrl);

                  // 2. 매장관리 페이지로 이동
                  Get.toNamed(Routes.manage, arguments: store.id)!
                      .then((value) {
                    // 뒤로가기 시, 나의 매장 전체 다시조회
                    controller.findAllMyStore();
                  });
                },
              );
            },
            viewportFraction: 0.88,
            scale: 0.95,
            loop: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneConnectButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 10),
          child: Center(
            child: Row(
              children: [
                CircleAvatar(
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  radius: 10,
                  backgroundColor: primaryColor.withOpacity(0.8),
                ),
                const SizedBox(width: 5),
                const Text(
                  '전화',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // 전화연결
      },
    );
  }

  Widget _buildNoStoreBox(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '등록된 매장이 없습니다.',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            '나의 매장을 등록해보세요!',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          IconTextRoundButton(
            icon: Icons.storefront_outlined,
            text: '매장 등록하기',
            tapFunc: () {
              // 매장등록 인트로 페이지로 이동
              controller.changeCurIndex(1);
            },
          ),
        ],
      ),
    );
  }
}
