import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(context, String message, int? duration) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xBB000000),
    ),
    child: Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(milliseconds: duration ?? 1500),
    gravity: ToastGravity.CENTER,
  );
}

void showErrorToast(context) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xBB000000),
    ),
    child: const Text(
      '오류가 발생했습니다.\n잠시후 다시 시도해 주세요.',
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: const Duration(milliseconds: 2000),
    gravity: ToastGravity.CENTER,
  );
}

void showNetworkDisconnectedToast(context) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xBB000000),
    ),
    child: const Text(
      '네트워크 연결 상태를 확인해 주세요.',
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: const Duration(milliseconds: 2000),
    gravity: ToastGravity.CENTER,
  );
}
