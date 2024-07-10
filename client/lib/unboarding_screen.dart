import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/theme/theme_class.dart';
import 'package:udharo/view/screens/sign_in_screen.dart';

class UnboardingScreen extends StatefulWidget {
  const UnboardingScreen({super.key});

  @override
  State<UnboardingScreen> createState() => _UnboardingScreenState();
}

class _UnboardingScreenState extends State<UnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          OnboardingPage(
            color: ThemeClass().backgroundColor,
            text: 'Welcome to Udharo!',
            buttonText: 'Next',
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingPage(
            color: ThemeClass().backgroundColor,
            text: 'Manage your finances easily.',
            buttonText: 'Next',
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingPage(
            color: ThemeClass().backgroundColor,
            text: 'Get started now!',
            buttonText: 'Get Started',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboardingComplete', true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final Color color;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  const OnboardingPage({
    Key? key,
    required this.color,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ThemeClass().secondaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
