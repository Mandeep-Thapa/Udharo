import 'package:flutter/material.dart';

class CustomImagewithLabel extends StatelessWidget {
  final String imageUrl;
  final String label;
  const CustomImagewithLabel({
    super.key,
    required this.imageUrl,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // image received from the server
        Image.network(
          imageUrl,

          // Display an error icon when image not found
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
            );
          },
        ),
        // spacing between the image and the label
        const SizedBox(height: 8),
        // label to display below the image
        Text(label),
      ],
    );
  }
}
