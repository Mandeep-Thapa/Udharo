import 'package:flutter/material.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formField = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formField,
            child: Column(
              children: [
                passwordFormFields(
                  'Old Password',
                  _oldPasswordController,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                passwordFormFields(
                  'New Password',
                  _newPasswordController,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                passwordFormFields(
                  'Confirm Password',
                  _confirmPasswordController,
                  isConfirmPassword: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formField.currentState!.validate()) {
                      // change password
                    }
                  },
                  child: const Text(
                    'Change Password',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  // validator
  // validator
  String? passwordValidator(String? value, {bool isConfirmPassword = false}) {
    if (value!.isEmpty) {
      return 'Field cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (isConfirmPassword && value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // form fields
  TextFormField passwordFormFields(
    String hintText,
    TextEditingController controller, {
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
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
      validator: (value) => passwordValidator(
        value,
        isConfirmPassword: isConfirmPassword,
      ),
    );
  }
}
