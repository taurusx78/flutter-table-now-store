import 'package:get/get.dart';

class SaveNoticeReqDto {
  final String title; // 제목
  final String content; // 내용
  final String holidayStartDate; // 임시휴무 시작일
  final String holidayEndDate; // 임시휴무 종료일
  final List<MultipartFile>? imageFileList; // 첨부사진 파일 목록
  final List<String>? deletedImageUrlList; // 삭제된 이미지 url 목록

  SaveNoticeReqDto({
    required this.title,
    required this.content,
    required this.holidayStartDate,
    required this.holidayEndDate,
    this.imageFileList,
    this.deletedImageUrlList,
  });

  // 데이터를 JSON 형식으로 변경
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'holidayStartDate': holidayStartDate,
        'holidayEndDate': holidayEndDate,
        'imageFileList': imageFileList,
        'deletedImageUrlList': deletedImageUrlList,
      };
}
