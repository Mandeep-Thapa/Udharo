import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udharo/view/widget/custom_show_full_screen_image.dart';
import 'package:udharo/view/widget/image_uploader.dart';

class CustomImageSelectionButton extends StatelessWidget {
  final File? image;
  final String label;
  final void Function(File?) onPressed;

  const CustomImageSelectionButton({
    super.key,
    this.image,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image != null)
          GestureDetector(
            onTap: () {
              CustomShowFullScreenImage().showFullScreenImage(
                context,
                image!.path,
                isFileImage: true,
                image: image,
              );
            },
            child: Image.file(
              image!,
            ),
          ),
        ElevatedButton(
          onPressed: () async {
            final photo = await ImageUploader().showImageSourceOptions(context);
            onPressed(photo);
          },
          child: Text(label),
        ),
      ],
    );
  }
}
