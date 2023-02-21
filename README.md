# TABLE NOW (매장용)
매장의 실시간 영업정보를 제공하는 앱의 매장용 버전이다.
<br><br>

## 설명
Flutter를 이용한 크로스플랫폼 앱으로 매장을 이용하려는 고객에게 실시간 매장 정보를 제공하는 역할을 한다.<br>
매장의 영업정보가 매장 상황에 따라 예기치 않게 임시 변동된 경우, 고객이 겪게 되는 불편함을 해결하기 위해 해당 서비스를 기획하게 되었다.<br>
1. 타입의 업체를 도용하는 문제를 방지하기 위해, 계정을 생성하고 로그인을 진행해야 서비스를 이용할 수 있다.
2. 영업시간, 잔여테이블 수 정보 등 매장 정보를 쉽게 변경하고 고객에게 제공할 수 있다.
3. 고객에게 전할 알림을 등록할 수 있으며, 알림 등록 시 임시휴무를 설정하면 영업시간 변경 없이 고객들에게 임시휴무 정보를 제공할 수 있다.
<br>

## 기술스택
- Flutter
- GetX (상태관리)
<br>

## Open API
- import 본인인증
  - [import 홈페이지](https://www.iamport.kr/)
  - [import 플러터 패키지](https://pub.dev/packages/iamport_flutter)
  <br>
- 네이버 지도 API
  - [네이버 지도 API 소개](https://www.ncloud.com/product/applicationService/maps)
  - [네이버 지도앱 연동 URL Scheme](https://guide.ncloud-docs.com/docs/naveropenapiv3-maps-url-scheme-url-scheme)
<br>

## 스크린샷 (일부)
<div>
  <img src="https://user-images.githubusercontent.com/56622731/211715421-217af15c-5881-4901-a013-8ea2590e2923.png" alt="로그인" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211715464-6926ddf6-1208-433a-abf0-3c8f78438312.png" alt="홈" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211715502-6cc72bf3-a94c-4a1d-adb8-d9cdafece6fb.png" alt="매장등록" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211715532-6dff3723-d7de-4112-9813-7f2a3f1b60fd.png" alt="매장관리" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211715553-91717577-6b57-4b8c-b465-120ed8e2c0f4.png" alt="알림등록" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211715583-9f99425c-415f-4e6e-a8b3-8a54f012b571.png" alt="내정보" width="200"/>
</div><br><br>

## 해결 필요한 문제
- 매장등록 실패 후 재시도 시 에러 발생<br>
```
Error: Unhandled Exception: Bad state: Stream has already been listened to.
```
Stream으로 전달되는 데이터(이벤트) 사용(구독)은 한 번만 가능한데, 같은 데이터를 여러 번 사용하려고 하는 경우 해당 에러 발생함
<br><br><br>

## 추가할 기능
- (예정) 일 조회수, 즐겨찾기 고객수, 정보수정제안 수 표시
  - 매장의 유의미한 통계 정보 제공
  <br>
- (예정) 매장등록 시 원산지 정보 입력 폼 추가
  - 맛과 안정성 등 고객에게 필요한 정보 제공
  <br>
- (보류) 앱 푸시 알림 기능
  - 고객이 매장 정보 수정 제안 시 메일 전송 대신 앱 푸시 알림 전송으로 변경
  <br>
- (보류) 포스기용 웹 프로그램
<br>
