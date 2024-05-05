import 'package:flutter/material.dart';

class CustomToast {
  void showToast({
    required BuildContext context,
    required String message,
  }) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(),
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
