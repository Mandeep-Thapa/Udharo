import 'package:flutter/material.dart';
import 'package:udharo/view/screens/accounts_screen.dart';
import 'package:udharo/view/screens/borrow_history_screen.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/screens/privacy_and_policy_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_settings_option.dart';
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
        title: const Text(
          'Settings',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              // navigate to home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            // account option
            const CustomSettingsOption(
              icon: Icons.person,
              title: 'Account',
              widget: AccountsPage(),
            ),

            // privacy and security dialog
            const CustomSettingsOption(
             icon:  Icons.lock,
             title:  'Privacy & Security',
             widget:  PrivacyPolicyPage(),
             isDialog: true,
            ),

            // history option
            const CustomSettingsOption(
             icon:  Icons.history,
             title:  'History',
             widget:  BorrowHistoryScreen(),
            ),

            // support option
            const CustomSettingsOption(
             icon:  Icons.help,
             title:  'Support',
             widget:  SettingsPage(),
            ),

            // sign out button
            const Spacer(),
            SizedBox(
              width: double.infinity,
            
              child: SignOutButton().signOutButton(context),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  
}
