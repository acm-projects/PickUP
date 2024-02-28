import 'package:flutter/material.dart';

class GameTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintTxt;
  final bool obscureTxt;

  const GameTextFields({
    Key? key,
    required this.controller,
    required this.hintTxt,
    required this.obscureTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textField = TextField(
      controller: controller,
      obscureText: obscureTxt,
      decoration: InputDecoration(
        hintText: hintTxt,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: textField,
    );
  }
}