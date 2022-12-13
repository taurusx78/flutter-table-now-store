import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsPage2 extends StatelessWidget {
  const TermsConditionsPage2({Key? key}) : super(key: key);

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
        title: const Text('이용약관'),
        elevation: 1,
      ),
      // body: ,
    );
  }
}
