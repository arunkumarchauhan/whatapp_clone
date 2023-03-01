import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  AppToast._();

  static showToast(
    String? message, {
    Color backgroundColor = Colors.grey,
    Toast duration = Toast.LENGTH_LONG,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message ?? "",
      toastLength: duration,
      gravity: gravity,
      backgroundColor: backgroundColor,
      timeInSecForIosWeb: 3,
      textColor: textColor,
      fontSize: 14,
    );
  }
}
