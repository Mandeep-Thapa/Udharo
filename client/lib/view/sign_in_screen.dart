import 'package:flutter/material.dart';
import 'package:udharo/view/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  // text editing controllers
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    // initialize text editing controllers
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login with email and password',
              ),
              // email field
              emailFormField(),

              // password field
              passwordFormField(),

              // buttons
              Center(
                child: Column(
                  children: [
                    // sign up button

                    TextButton(
                      onPressed: () {
                        // sign in logic
                      },
                      child: const Text('Sign In'),
                    ),

                    // already registered button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text('Not Registered? Sign Up!'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // form fields
  TextField emailFormField() {
    return TextField(
      controller: _emailController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
    );
  }

  TextField passwordFormField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: GestureDetector(
          onTap: () {
            setState(
              () {
                _isPasswordVisible = !_isPasswordVisible;
              },
            );
          },
          child: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
