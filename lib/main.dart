import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/my_scroll_behavior.dart';
import 'package:table_now_store/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 세로 방향 고정
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // 안드로이드, iOS 상태바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: Routes.login,
      getPages: Pages.routes,
      // 스크롤 반짝임 효과 제거
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: child!,
        );
      },
      // 기본 언어로 한글 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KO'),
      ],
    );
  }
}
