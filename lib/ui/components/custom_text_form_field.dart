import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class CustomTextFormField extends StatelessWidget {
  final double? width;
  final String hint;
  final dynamic controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLength;
  final String? counterText; // 최대 글자수 표시 여부
  final bool? enabled;
  final dynamic validator;
  final dynamic tapFunc;

  const CustomTextFormField({
    Key? key,
    this.width,
    required this.hint,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText,
    this.maxLength,
    this.counterText,
    this.enabled,
    this.validator,
    this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 600,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLength: maxLength,
        enabled: enabled ?? true,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          counterText: counterText,
          contentPadding: const EdgeInsets.all(15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: blueGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: blueGrey, width: 1),
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
          errorMaxLines: 2, // 유효성검사 문구 말줄임 방지
        ),
        onTap: tapFunc,
      ),
    );
  }
}
