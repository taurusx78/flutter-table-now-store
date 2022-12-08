import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class CustomTextArea extends StatelessWidget {
  final String hint;
  final dynamic controller;
  final dynamic validator;

  const CustomTextArea({
    Key? key,
    required this.hint,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        maxLength: 500,
        maxLines: 7,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.all(15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: blueGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorStyle: const TextStyle(fontSize: 14, color: darkNavy),
        ),
      ),
    );
  }
}
