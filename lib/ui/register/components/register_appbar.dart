import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';

class RegisterAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  RegisterAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text(title),
      actions: [
        IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            _showDialog(context);
          },
        ),
      ],
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return CustomDialog(
          title: '입력을 중단하시겠습니까?',
          checkFunc: () {
            Navigator.pop(context);
            Get.offAllNamed(Routes.main);
          },
        );
      },
    );
  }
}
