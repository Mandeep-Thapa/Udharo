import 'package:flutter/material.dart';

class CustomDialogBox {
  static void showCustomDialogBox(
    BuildContext context,
    String title,
    Widget content,
    VoidCallback? onpressed, {
    String buttonName = 'Ok',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: onpressed,
              child: Text(buttonName),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
