import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/login_bloc/login_bloc.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/screens/sign_up_screen.dart';
import 'package:udharo/view/widget/custom_toast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  final _formField = GlobalKey<FormState>();


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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formField,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // header Image
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    'lib/assets/sign_in_background_image.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome to Udharo',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Get access to the tools you need to invest, spend, and put your money in motion.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
            
                // email field
                emailField(),
                const SizedBox(height: 20),
            
                passwordField(),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              // login button
                BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginStateSuccess) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Login successful',
                            );
            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
            
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginEventResetLogin(),
                            );
                          } else if (state is LoginStateError) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Login failed: ${state.message}',
                            );
            
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginEventResetLogin(),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                             width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(_formField.currentState!.validate()){
                                  context.read<LoginBloc>().add(
                                      LoginEventSignIn(
                                        _emailController.text,
                                        _passwordController.text,
                                      ),
                                    );
                                }
                              },
                              child: const Text('Login'),
                            ),
                          );
                        },
                      ),
                const SizedBox(
                  height: 10,
                ),
                // go to  sign up screen button
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
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
  TextFormField emailField() {
    return TextFormField(
      controller: _emailController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Please enter your email';
        }
        return null;
      
      },
    );
  }

  TextFormField passwordField() {
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
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Please enter your email';
        }
        return null;
      
      },
    );
  }
}
