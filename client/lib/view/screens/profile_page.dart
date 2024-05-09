import 'package:flutter/material.dart';
import 'package:udharo/view/screens/borrow_history_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/sign_out_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          SignOutButton().signOutButton(context),
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
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
