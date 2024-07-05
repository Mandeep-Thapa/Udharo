import 'dart:io';

import 'package:flutter/material.dart';

class CustomShowFullScreenImage {
  void showFullScreenImage(
    BuildContext context,
    String imageUrl, {
    bool isFileImage = false,
    File? image,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (isFileImage) ? Image.file(image!) : Image.network(imageUrl),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
