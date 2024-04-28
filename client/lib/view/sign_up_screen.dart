import 'package:flutter/material.dart';
import 'package:udharo/view/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formField = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // text editing controllers
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    // initialize text editing controllers
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

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
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register with email and password',
                ),
                // email field
                emailFormField(),

                // password field
                passwordFormField(),

                // confirm password field
                confirmPasswordFormField(),

                // buttons
                Center(
                  child: Column(
                    children: [
                      // sign up button

                      TextButton(
                        onPressed: () {
                          if (_formField.currentState!.validate()) {
                            // form is valid
                          }
                        },
                        child: const Text('Sign Up'),
                      ),

                      // already registered button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text('Already Registered? Login!'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // form fields
  TextFormField emailFormField() {
    return TextFormField(
      controller: _emailController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email cannot be empty';
        }
        if (value.startsWith(RegExp(r'[0-9]'))) {
          return 'Email name cannot start with a number';
        }
        bool emailValid = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value);
        if (!emailValid) {
          return "Enter valid Email";
        }
        return null;
      },
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password cannot be empty';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  TextFormField confirmPasswordFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _isPasswordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
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
      validator: (value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
