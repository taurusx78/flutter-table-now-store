import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// 네이버지도 API를 호출하는 Controller

class LocationController extends GetxController {
  Rx<Uint8List> bytesImage = Uint8List(0).obs;
  final RxBool loaded = true.obs; // 지도 조회 완료 여부

  Future<void> getLocationMap(double lon, double lat) async {
    loaded.value = false;

    Map<String, String> headers = {
      // Client ID
      'X-NCP-APIGW-API-KEY-ID': dotenv.env['naverMapClientId']!,
      // Client Secret
      'X-NCP-APIGW-API-KEY': dotenv.env['naverMapClientSecret']!,
    };

    var response = await http.get(
      Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?w=400&h=250&markers=type:d|size:mid|pos:$lon%20$lat|viewSizeRatio:0.5&scale=2'),
      headers: headers,
    );

    bytesImage.value = response.bodyBytes;
    loaded.value = true;
  }
}
