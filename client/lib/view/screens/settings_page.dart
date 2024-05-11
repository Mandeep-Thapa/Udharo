import 'package:flutter/material.dart';
import 'package:udharo/view/screens/borrow_history_screen.dart';
import 'package:udharo/view/screens/kyc_form_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/sign_out_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // sign out button
          SignOutButton().signOutButton(context),

          // history page
          GestureDetector(
            onTap: () {
              // navigate to history page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BorrowHistoryScreen(),
                ),
              );
            },
            child: const Text('View History'),
          ),

          const SizedBox(height: 20),

          // kyc page
          GestureDetector(
            onTap: () {
              // navigate to history page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const KYCFormScreen(),
                ),
              );
            },
            child: const Text('KYC Verification'),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
