import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/data/repository/auth_repository.dart';
import 'package:udharo/service/login_bloc/login_bloc.dart';
import 'package:udharo/service/register_bloc/register_bloc.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token');

  runApp(
    MyApp(
      isUserLoggedIn: token != null,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isUserLoggedIn;
  const MyApp({
    super.key,
    required this.isUserLoggedIn,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            AuthRepository(),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            AuthRepository(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Udharo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: widget.isUserLoggedIn ? const HomePage() : const SignUpScreen(),
      ),
    );
  }
}
