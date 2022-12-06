import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/main_controller.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/ui/home/home_page.dart';
import 'package:table_now_store/ui/mypage/my_page.dart';
import 'package:table_now_store/ui/register/register_intro_page.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final List<Widget> pages = [
    const HomePage(),
    const RegisterIntroPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        // 홈이 아닐 때 뒤로가기 누를 경우, 홈으로 이동
        onWillPop: () async {
          if (controller.curIndex.value == 0) {
            return true;
          } else {
            controller.changeCurIndex(0);
            return false;
          }
        },
        child: Scaffold(
          body: pages[controller.curIndex.value],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.curIndex.value,
              onTap: (index) {
                controller.changeCurIndex(index);
              },
              // 각 아이템 간격 고정
              type: BottomNavigationBarType.fixed,
              backgroundColor: darkNavy,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xff8f9db6),
              selectedFontSize: 13,
              unselectedFontSize: 13,
              items: const [
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 40,
                    child: Icon(Icons.home_rounded, size: 30),
                  ),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 40,
                    child: Icon(Icons.add_location, size: 30),
                  ),
                  label: '매장등록',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 40,
                    child: Icon(Icons.person_rounded, size: 30),
                  ),
                  label: '내정보',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
