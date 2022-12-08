import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class AddImageButton extends StatelessWidget {
  final dynamic tapFunc;

  const AddImageButton({Key? key, required this.tapFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: blueGrey),
        ),
        child: const Center(
          child: Icon(Icons.add_a_photo, color: primaryColor, size: 30),
        ),
      ),
      onTap: tapFunc,
    );
  }
}
