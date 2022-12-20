import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now_store/controller/store/delete_store_controller.dart';
import 'package:table_now_store/route/routes.dart';
import 'package:table_now_store/ui/components/custom_dialog.dart';
import 'package:table_now_store/ui/components/custom_text_form_field.dart';
import 'package:table_now_store/ui/components/loading_container.dart';
import 'package:table_now_store/ui/components/show_toast.dart';
import 'package:table_now_store/ui/components/state_round_button.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/validator_util.dart';

class DeleteStorePage extends GetView<DeleteStoreController> {
  DeleteStorePage({Key? key}) : super(key: key);

  final int storeId = Get.arguments[0];
  final String name = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.clear_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                  const Text(
                    '매장삭제 안내',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/fail.png',
                    width: 80,
                    color: darkNavy,
                  ),
                  const SizedBox(height: 50),
                  // 안내 문구
                  _buildGuideText(),
                  const SizedBox(height: 50),
                  // 비밀번호 확인 폼
                  _buildPwCheckForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            children: const [
              TextSpan(
                text: '을(를) 삭제하시겠습니까?',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '삭제 이후에는 취소 및 데이터 복구가 불가능합니다.',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 30),
        RichText(
          text: const TextSpan(
            text: '매장 삭제를 원하시는 경우, 아래에 계정 비밀번호를 입력 후 ',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '매장 삭제하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              TextSpan(
                text: ' 버튼을 눌러주세요.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPwCheckForm(context) {
    return Column(
      children: [
        // 비밀번호
        Form(
          key: controller.curPwFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextFormField(
            hint: '비밀번호를 입력해주세요.',
            controller: controller.password,
            obscureText: true,
            maxLength: 20,
            counterText: '',
            validator: validateCurPassword(),
          ),
        ),
        const SizedBox(height: 15),
        // 매장삭제 버튼
        Obx(
          () => StateRoundButton(
            text: '매장 삭제하기',
            activated: controller.activated.value,
            tapFunc: () {
              _showDialog(context);
            },
          ),
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
          title: '매장을 정말로 삭제하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context2);
            _showProcessingDialog(context);
          },
        );
      },
    );
  }

  void _showProcessingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      barrierColor: Colors.transparent,
      builder: (BuildContext context2) {
        // 매장 삭제 진행
        controller.deleteById(storeId).then((result) {
          // 해당 showDialog는 AlertDialog가 아닌 Container를 리턴하기 때문에 context2가 아닌 context를 pop() 함
          Navigator.pop(context);
          if (result == 1) {
            showToast(context, '매장이 삭제되었습니다.', null);
            Get.offAllNamed(Routes.main);
          } else if (result == -1) {
            showToast(context, '비밀번호가 일치하지 않습니다.', null);
          } else if (result == -2) {
            showToast(context, '권한이 없는 사용자입니다.', null);
          } else if (result == -3) {
            showNetworkDisconnectedToast(context);
          }
        });

        return const LoadingContainer(text: '삭제중');
      },
    );
  }
}
