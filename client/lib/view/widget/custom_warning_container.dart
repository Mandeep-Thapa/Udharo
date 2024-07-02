import 'package:flutter/material.dart';
import 'package:udharo/theme/theme_class.dart';

class CustomWarningContainer extends StatelessWidget {
  final String message;
  const CustomWarningContainer({super.key,  required this.message,});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeClass().errorColor,
      width: double.infinity,
      child: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        )
        
      )
    );
  }
}