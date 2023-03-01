import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.nameOfField,
    this.obscureText = false,
  }) : super(key: key);
  final TextEditingController controller;
  final String nameOfField;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 45,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 25),
            hintText: nameOfField,
            labelText: nameOfField,
            hintStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w200),
            labelStyle: const TextStyle(color: Colors.black),
            helperStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w200),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Colors.teal),
            )),
      ),
    );
  }
}
