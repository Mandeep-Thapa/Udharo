import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/view/screens/sign_up_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Udaro'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                // sign out
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('token');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                });
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
