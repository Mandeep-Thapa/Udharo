import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  final ImagePicker _picker = ImagePicker();

  // method to show image source options
  Future<File?> showImageSourceOptions(BuildContext context) async {
    File? image;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                ),
                title: const Text(
                  'Take a picture',
                ),
                onTap: () async {
                  image = await selectImageFromSource(
                    ImageSource.camera,
                  );

                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                ),
                title: const Text(
                  'Choose from gallery',
                ),
                onTap: () async {
                  image = await selectImageFromSource(
                    ImageSource.gallery,
                  );
                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    return image;
  }

  // method to select image from source
  Future<File?> selectImageFromSource(
    ImageSource source,
  ) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 30,
    );
    if (image == null) {
      return null;
    } else {
      return File(image.path);
    }
  }
}
