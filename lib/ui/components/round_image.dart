import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';
import 'package:table_now_store/util/host.dart';

class RoundImage extends StatelessWidget {
  final double? width;
  final String type;
  final dynamic image;
  final dynamic deleteFunc;

  const RoundImage({
    Key? key,
    this.width,
    required this.type,
    required this.image,
    required this.deleteFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width ?? 120,
          height: width ?? 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: blueGrey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: image!.runtimeType == String
                ? Image.network(
                    '$host/image?type=$type&filename=$image',
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(image!.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // 삭제 버튼
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            icon: const Icon(Icons.remove_circle, color: red),
            splashRadius: 20,
            onPressed: deleteFunc,
          ),
        ),
      ],
    );
  }
}
