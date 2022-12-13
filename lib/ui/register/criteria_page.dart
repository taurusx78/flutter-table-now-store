import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CriteriaPage extends StatelessWidget {
  const CriteriaPage({Key? key}) : super(key: key);

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
        title: const Text('매장등록기준'),
      ),
      body: Container(),
    );
  }
}
