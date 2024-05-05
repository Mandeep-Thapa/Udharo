import 'package:flutter/material.dart';

class CustomToast {
  Future<String> showToast({
    required BuildContext context,
    required String message,
  }) async {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(
          // horizontal: 12,
          // vertical: 10,
          ),
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          // fontSize: 10.sp,
          // color: white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    throw (snackBar);
  }
}
