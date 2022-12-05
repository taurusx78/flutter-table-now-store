import 'package:flutter/material.dart';
import 'package:table_now_store/ui/custom_color.dart';

class LoginTextFormField extends StatelessWidget {
  final String hint;
  final dynamic controller;

  const LoginTextFormField({
    Key? key,
    required this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      obscureText: hint == '비밀번호' ? true : false,
      maxLength: 20,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        counterText: '',
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: blueGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
