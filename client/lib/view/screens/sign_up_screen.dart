import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/register_bloc/register_bloc.dart';
import 'package:udharo/view/screens/sign_in_screen.dart';
import 'package:udharo/view/widget/custom_toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formField = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // text editing controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _occupationController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    // initialize text editing controllers
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _occupationController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Register with name, email and password',
                ),

                Row(
                  children: [
                    // first name field
                    Expanded(
                      child: firstNameFormField(),
                    ),

                    // last name field
                    Expanded(
                      child: lastNameFormField(),
                    ),
                  ],
                ),

                // email field
                emailFormField(),

                // occupation field
                occupationFormField(),

                // password field
                passwordFormField(),

                // confirm password field
                confirmPasswordFormField(),

                // buttons
                Center(
                  child: Column(
                    children: [
                      // sign up button

                      BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterStateSuccessSigningUp) {
                            context.read<RegisterBloc>().add(
                                  RegisterEventSendEmailVerification(
                                    email: state.email,
                                  ),
                                );
                          } else if (state
                              is RegisterStateSuccessSendingVerificationEmail) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Registration successful',
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          } else if (state is RegisterStateError) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Registration failed: ${state.message}',
                            );
                          } else if (state is RegisterStateLoading) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Loading...',
                            );
                          }
                        },
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () {
                              if (_formField.currentState!.validate()) {
                                // form is valid
                                context.read<RegisterBloc>().add(
                                      RegiserEventMakeRegistration(
                                        name: '${_firstNameController.text} ${_lastNameController.text}',
                                        email: _emailController.text,
                                        occupation: _occupationController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                              }
                            },
                            child: const Text('Sign Up'),
                          );
                        },
                      ),

                      // already registered button
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
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
  TextFormField firstNameFormField() {
    return TextFormField(
      controller: _firstNameController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        hintText: 'First Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'First Name cannot be empty';
        }
        if (value.startsWith(RegExp(r'[0-9]'))) {
          return 'First name cannot start with a number';
        }
        bool nameValid = RegExp(
          r"^[a-zA-Z\-'. ]+$",
        ).hasMatch(value);
        if (!nameValid) {
          return "Enter valid First Name";
        }
        return null;
      },
    );
  }

  TextFormField lastNameFormField() {
    return TextFormField(
      controller: _lastNameController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        hintText: 'Last Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Last Name cannot be empty';
        }
        if (value.startsWith(RegExp(r'[0-9]'))) {
          return 'Last name cannot start with a number';
        }
        bool nameValid = RegExp(
          r"^[a-zA-Z\-'. ]+$",
        ).hasMatch(value);
        if (!nameValid) {
          return "Enter valid Last Name";
        }
        return null;
      },
    );
  }

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

  TextFormField occupationFormField() {
    return TextFormField(
      controller: _occupationController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Occupation',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Occupation cannot be empty';
        }
        if (value.startsWith(RegExp(r'[0-9]'))) {
          return 'Occupation name cannot start with a number';
        }
        bool occupationValid = RegExp(
          r"^[a-zA-Z\-'. ]+$",
        ).hasMatch(value);
        if (!occupationValid) {
          return "Enter valid Occupation";
        }
        return null;
      },
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
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
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }

  TextFormField confirmPasswordFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isPasswordVisible,
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
