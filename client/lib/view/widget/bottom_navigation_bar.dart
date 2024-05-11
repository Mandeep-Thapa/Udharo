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
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // home button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            icon: const Icon(Icons.home),
          ),

          // browse button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrowseBorrowRequestsPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),

          // add button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateBorrowRequestPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),

          // profile button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
