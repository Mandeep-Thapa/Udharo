import 'package:flutter/material.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/screens/profile_page.dart';

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
            onPressed: () {},
            icon: const Icon(Icons.money),
          ),

          // add button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),

          // profile button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
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
