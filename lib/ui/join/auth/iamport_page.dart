import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamport_flutter/Iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';

class IamportPage extends StatelessWidget {
  IamportPage({Key? key}) : super(key: key);

  // 아임포트에서 제공하는 테스트 코드 (발급받은 번호로 변경 필요)
  static const String userCode = 'imp10391932';

  String? phone = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return IamportCertification(
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
        title: const Text('휴대폰 본인인증'),
      ),
      // 웹뷰 로딩 컴포넌트
      initialChild: const Center(
        child: Text(
          '잠시만 기다려주세요...',
          style: TextStyle(fontSize: 18),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp10391932',
      /* [필수입력] 본인인증 데이터 */
      data: CertificationData(
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        company: '아임포트', // 회사명 또는 URL
        carrier: '', // 통신사
        name: '', // 이름
        phone: phone ?? '', // 핸드폰번호
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        // 본인인증 진행 후 실행됨
        Get.back(result: result);
      },
    );
  }
}
