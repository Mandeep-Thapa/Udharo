import 'package:flutter/material.dart';
import 'package:udharo/view/screens/browse_borrow_requests_screen.dart';
import 'package:udharo/view/screens/create_borrow_request_page.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/screens/settings_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  // final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    // required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // home button
          selectItems(
            text: 'Home',
            icon: Icons.home,
            widget: const HomePage(),
            context: context,
          ),

          // browse button
          selectItems(
            text: 'Search',
            icon: Icons.search,
            widget: const BrowseBorrowRequestsPage(),
            context: context,
          ),

          // add button

          selectItems(
            text: 'Invest',
            icon: Icons.arrow_circle_up,
            widget: const CreateBorrowRequestPage(),
            context: context,
          ),

          // settings button
          selectItems(
            text: 'Settings',
            icon: Icons.settings,
            widget: const SettingsPage(),
            context: context,
          ),
        ],
      ),
    );
  }

  // function to select items
  GestureDetector selectItems({
    required String text,
    required IconData icon,
    required Widget widget,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Icon(icon),
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
