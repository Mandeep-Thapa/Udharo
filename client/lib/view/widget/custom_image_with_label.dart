import 'package:flutter/material.dart';

class CustomImagewithLabel extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isnetworkImage;
  const CustomImagewithLabel({
    super.key,
    required this.imageUrl,
    required this.label,
    this.isnetworkImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // image received from the server
        (isnetworkImage)?
        Image.network(
          imageUrl,

          // Display an error icon when image not found
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
            );
          },
        )
        :Image.asset(
          imageUrl,
        ),
        // spacing between the image and the label
        const SizedBox(height: 8),
        // label to display below the image
        Text(label),
      ],
    );
  }
}
