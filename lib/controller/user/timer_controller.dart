import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? timer;
  final RxInt duration = 300.obs; // 유효 시간 5분
  final RxString minutes = '5'.obs; // 남은 분
  final RxString seconds = '00'.obs; // 남은 초

  // 타이머 시작
  void startTimer() {
    duration.value = 300; // 유효 시간 5분
    minutes.value = '5'; // 남은 분
    seconds.value = '00'; // 남은 초

    // 1초 간격으로 카운트
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration.value -= 1;
      if (duration.value == 0) {
        endTimer(); // 타이머 종료
      }
      minutes.value = (duration.value ~/ 60).toString();
      seconds.value = (duration.value % 60).toString().padLeft(2, '0');
    });
  }

  // 타이머 종료
  void endTimer() {
    timer!.cancel();
  }
}
