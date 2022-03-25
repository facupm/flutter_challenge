import 'package:flutter/material.dart';

class CustomSnackBar {

  CustomSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 10),
      ));
  }
}
