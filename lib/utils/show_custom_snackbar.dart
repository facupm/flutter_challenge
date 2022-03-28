import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomSnackBar {

  CustomSnackBar(String message, BuildContext context) {

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ));
    });
  }
}
