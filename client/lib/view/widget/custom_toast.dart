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
       
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
