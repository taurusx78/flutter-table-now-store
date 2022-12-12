import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/dto/store/update_basic_resp_dto.dart';
import 'package:table_now_store/controller/dto/store/update_inside_resp_dto.dart';
import 'package:table_now_store/controller/store/basic_controller.dart';
import 'package:table_now_store/controller/store/holidays_controller.dart';
import 'package:table_now_store/controller/store/hours_controller.dart';
import 'package:table_now_store/controller/store/inside_controller.dart';
import 'package:table_now_store/controller/store/manage_controller.dart';
import 'package:table_now_store/controller/store/menu_controller.dart';
import 'package:table_now_store/data/store/model/today.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_divider.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/manage/tables/tables_page.dart';
import 'package:table_now_store/ui/manage/today/today_page.dart';
import 'package:table_now_store/ui/screen_size.dart';
import 'package:table_now_store/util/host.dart';

import 'notice/notice_page.dart';

class ManagePage extends GetView<ManageController> {
  ManagePage({Key? key}) : super(key: key);

  int storeId = Get.arguments;

  TabBar get _tabBar => const TabBar(
        tabs: [
          Tab(text: '영업시간'),
          Tab(text: '테이블 수'),
          Tab(text: '알림'),
        ],
        indicatorWeight: 3,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.black54,
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: controller.scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                Obx(
                  () => SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      sliver: SliverAppBar(
                        // 축소 시 상단에 AppBar 고정
                        pinned: true,
                        expandedHeight: 250,
                        // 탭바
                        bottom: PreferredSize(
                          preferredSize: _tabBar.preferredSize,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: blueGrey, width: 2),
                              ),
                              color: Colors.white,
                            ),
                            child: _tabBar,
                          ),
                        ),
                        leading: IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        foregroundColor: controller.appBarIconColor.value,
                        // 매장명
                        title: Text(
                          controller.storeInfo.value!.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: controller.appBarTextColor.value,
                          ),
                        ),
                        // 대표사진
                        flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                            '$host/image?type=basic&filename=${controller.storeInfo.value!.basicImageUrl}',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: _buildTabBarView(),
          ),
        ),
        endDrawer: _buildDrawer(context),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * 0.5 > 200
          ? 200
          : getScreenWidth(context) * 0.5,
      color: Colors.white,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: darkNavy,
                  ),
                  child: const Text(
                    '매장관리',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _buildHeaderText(Icons.access_time_rounded, '영업시간'),
                // 영업시간 설정
                _buildBodyButton(context, '영업시간 설정', () {
                  Navigator.pop(context);
                  // 영업시간 조회 및 초기화 (비동기 실행)
                  Get.put(HoursController()).findHours(storeId);
                  Get.toNamed(Routes.hoursInfo, arguments: storeId)!
                      .then((result) {
                    // 수정 성공 (Today), 실패 (-1), 뒤로가기 (null)
                    if (result != null) {
                      if (result.runtimeType == Today) {
                        // 수정된 오늘의 영업시간 반영
                        controller.changeToday(result);
                        showToast(context, '영업시간을 수정하였습니다.', null);
                      } else {
                        showErrorToast(context);
                      }
                    }
                  });
                }),
                // 정기휴무 설정
                _buildBodyButton(context, '정기휴무 설정', () {
                  Navigator.pop(context);
                  // 정기휴무 조회 및 초기화 (비동기 실행)
                  Get.put(HolidaysController()).findHolidays(storeId);
                  Get.toNamed(Routes.holidaysInfo, arguments: storeId)!
                      .then((result) {
                    // 수정 성공 (Today), 실패 (-1), 뒤로가기 (null)
                    if (result != null) {
                      if (result.runtimeType == Today) {
                        // 수정된 오늘의 영업시간 반영
                        controller.changeToday(result);
                        showToast(context, '정기휴무를 수정하였습니다.', null);
                      } else {
                        showErrorToast(context);
                      }
                    }
                  });
                }),
                const SizedBox(height: 10),
                _buildHeaderText(Icons.book_outlined, '메뉴'),
                // 메뉴 관리
                _buildBodyButton(context, '메뉴 관리', () {
                  Navigator.pop(context);
                  // 메뉴정보 조회 및 초기화 (비동기 실행)
                  Get.put(MenuController()).findMenu(storeId);
                  Get.toNamed(Routes.menuInfo, arguments: storeId)!
                      .then((result) {
                    // 수정 성공 (1), 실패 (-1)
                    if (result != null) {
                      if (result == 1) {
                        showToast(context, '메뉴를 수정하였습니다.', null);
                      } else {
                        showErrorToast(context);
                      }
                    }
                  });
                }),
                const SizedBox(height: 10),
                _buildHeaderText(Icons.storefront_outlined, '매장'),
                // 매장내부정보
                _buildBodyButton(context, '매장내부정보', () {
                  Navigator.pop(context);
                  // 매장내부정보 조회 및 초기화 (비동기 실행)
                  Get.put(InsideController()).findInside(storeId);
                  Get.toNamed(Routes.insideInfo, arguments: storeId)!
                      .then((result) {
                    // 수정 성공 (UpdateInsideRespDto), 실패 (-1), 뒤로가기 (null)
                    if (result != null) {
                      if (result.runtimeType == UpdateInsideRespDto) {
                        // 수정된 전체테이블 수 반영
                        controller.changeTables(result);
                        showToast(context, '매장내부정보를 수정하였습니다.', null);
                      } else {
                        showErrorToast(context);
                      }
                    }
                  });
                }),
                // 기본정보
                _buildBodyButton(context, '기본정보', () {
                  Navigator.pop(context);
                  // 기본정보 조회 (비동기 실행)
                  Get.put(BasicController()).findBasic(storeId);
                  Get.toNamed(Routes.basicInfo, arguments: storeId)!
                      .then((result) {
                    // 수정 성공 (UpdateBasicRespDto), 실패 (-1), 뒤로가기 (null)
                    if (result != null) {
                      if (result.runtimeType == UpdateBasicRespDto) {
                        // 수정된 매장명 & 대표사진 반영
                        controller.setStoreInfo(
                            result.name, result.basicImageUrl);
                        showToast(context, '기본정보를 수정하였습니다.', null);
                      } else {
                        showErrorToast(context);
                      }
                    }
                  });
                }),
                const CustomDivider(top: 10, bottom: 10),
                _buildHeaderText(Icons.insert_chart_outlined, '매장통계'),
                _buildBodyButton(context, '매장 조회수', () {
                  Navigator.pop(context);
                  // 페이지 이동 전 미리 매장 조회수 조회 (비동기 실행)
                  // _updateStoreController.findInsideById(store.id);
                  // _updateStoreController.initializeInsidePage();
                  // Get.toNamed(Routes.insideInfo);
                }),
                const SizedBox(height: 120),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: lightGrey,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 매장삭제 버튼
                  _buildDeleteStoreButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(IconData icon, String text) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 14))
        ],
      ),
    );
  }

  Widget _buildBodyButton(context, String text, dynamic routeFunc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.white,
        child: InkWell(
          child: Container(
            height: 45,
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          onTap: routeFunc,
        ),
      ),
    );
  }

  Widget _buildDeleteStoreButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.delete_forever_outlined,
              color: Colors.black54,
              size: 18,
            ),
            Text(
              ' 매장삭제',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.black54,
              size: 18,
            ),
          ],
        ),
        onTap: () {
          Get.toNamed(Routes.deleteStore,
              arguments: [storeId, controller.storeInfo.value!.name]);
        },
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      // 슬라이드를 통한 탭바 이동 방지
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TodayPage(storeId: storeId),
        TablesPage(storeId: storeId),
        NoticePage(storeId: storeId),
      ],
    );
  }
}
