import 'package:flutter/material.dart';

class CustomDetailsContainer extends StatelessWidget {
  final List<Widget> fields;
  final bool showButton;
  final VoidCallback? onPressed;
  final String? buttonName;

  const CustomDetailsContainer({
    super.key,
    this.fields = const [],
    this.showButton = false,
    this.buttonName = 'Button',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: ThemeClass().secondaryColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...fields,
          if (showButton) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonName ?? 'Button'),
            ),
          ],
        ],
      ),
    );
  }
}
