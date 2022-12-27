import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_now_store/controller/store/manage_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/loading_indicator.dart';
import 'package:table_now_store/ui/components/network_disconnected_text.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/custom_color.dart';

class TablesPage extends GetView<ManageController> {
  final int storeId;

  TablesPage({Key? key, required this.storeId}) : super(key: key);

  var tables;

  @override
  Widget build(BuildContext context) {
    print('테이블 정보 빌드');

    return Obx(() {
      if (controller.loaded.value) {
        tables = controller.tables.value;
        if (tables != null) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 600,
                margin: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // 사용가능 테이블 수 정보
                    _buildTableCountInfo(),
                    const SizedBox(height: 20),
                    // 업데이트 시간
                    _buildUpdatedTimeText(),
                    const SizedBox(height: 50),
                    // 테이블 수 조작 버튼 모음
                    _buildCountButtons(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return NetworkDisconnectedText(
            retryFunc: () {
              // 잔여테이블 수 조회 (비동기 실행)
              controller.findTables(storeId);
            },
          );
        }
      } else {
        return const LoadingIndicator();
      }
    });
  }

  Widget _buildTableCountInfo() {
    return Column(
      children: [
        // 사용가능 테이블 수 퍼센트
        CircularPercentIndicator(
          radius: 110,
          lineWidth: 10,
          percent: controller.availablePercent.value,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    // 잔여테이블 수
                    TextSpan(
                      text: '${tables.tableCount}',
                      style: TextStyle(
                        fontSize: 45,
                        color: controller.tableColor.value,
                      ),
                    ),
                    // 전체테이블 수
                    TextSpan(
                      text: ' / ${tables.allTableCount}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '(잔여 / 전체)',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          progressColor: controller.tableColor.value,
          animation: true,
          animateFromLastPercent: true,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }

  Widget _buildUpdatedTimeText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.update_rounded,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          '업데이트 ${tables.modifiedDate}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCountButtons(context) {
    return !tables.paused
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 감소 버튼
              _buildCountButton(context, Icons.remove_rounded, '감소',
                  primaryColor, Colors.white),
              const SizedBox(width: 15),
              // 증가 버튼
              _buildCountButton(
                  context, Icons.add_rounded, '증가', primaryColor, Colors.white),
              const SizedBox(width: 15),
              // 초기화 버튼
              _buildCountButton(
                  context, Icons.refresh, '초기화', primaryColor, Colors.white),
              const SizedBox(width: 15),
              // 임시중지 버튼
              _buildCountButton(context, Icons.stop, '임시중지', lightGrey, red),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 감소 버튼
              _buildCountButton(context, Icons.remove_rounded, '감소', lightGrey,
                  Colors.black54),
              const SizedBox(width: 15),
              // 증가 버튼
              _buildCountButton(
                  context, Icons.add_rounded, '증가', lightGrey, Colors.black54),
              const SizedBox(width: 15),
              // 초기화 버튼
              _buildCountButton(
                  context, Icons.refresh, '초기화', lightGrey, Colors.black54),
              const SizedBox(width: 15),
              // 중지해제 버튼
              _buildCountButton(
                  context, Icons.stop, '중지해제', primaryColor, Colors.white),
            ],
          );
  }

  Widget _buildCountButton(context, IconData icon, String label,
      Color filledColor, Color iconColor) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: filledColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Icon(icon, color: iconColor, size: 30),
              ),
              onTap: () async {
                if (controller.today.value!.state == '영업중') {
                  int result = 0;
                  if (!tables.paused) {
                    switch (label) {
                      case '감소':
                        result = await controller.updateTableCount(
                            storeId, 0, false);
                        break;
                      case '증가':
                        result = await controller.updateTableCount(
                            storeId, 1, false);
                        break;
                      case '초기화':
                        _showDialog(context, '테이블 수를 초기화 하시겠습니까?', null,
                            () async {
                          Navigator.pop(context!);
                          result = await controller.updateTableCount(
                              storeId, 2, false);
                        });
                        break;
                      case '임시중지':
                        _showDialog(context, '잔여 테이블 수 제공을 임시중지 하시겠습니까?',
                            '임시중지 시 매장 검색 결과 노출에 제한됩니다.', () async {
                          Navigator.pop(context!);
                          result = await controller.updateTableCount(
                              storeId, 3, true);
                        });
                        break;
                    }
                  } else {
                    if (label == '중지해제') {
                      _showDialog(context, '잔여테이블 수를 제공하시겠습니까?',
                          '테이블 정보를 제공하고 고객의 만족도를 높여보세요!', () async {
                        Navigator.pop(context!);
                        result = await controller.updateTableCount(
                            storeId, 3, false);
                      });
                    } else {
                      showToast(context, '임시중지를 먼저 해제해 주세요.', null);
                    }
                  }

                  if (result == 403) {
                    Get.offAllNamed(Routes.login);
                    Get.snackbar('알림', '권한이 없는 사용자입니다.\n다시 로그인해 주세요.');
                  } else if (result == 500) {
                    showNetworkDisconnectedToast(context);
                  } else {
                    showErrorToast(context);
                  }
                } else {
                  showToast(
                      context, '${controller.today.value!.state}입니다.', null);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(label),
      ],
    );
  }

  void _showDialog(context, String title, String? content, dynamic checkFunc) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: content,
          checkFunc: checkFunc,
        );
      },
    );
  }
}
