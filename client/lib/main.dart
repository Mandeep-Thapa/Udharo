import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:udharo/data/repository/auth_repository.dart';
import 'package:udharo/data/repository/borrow_repository.dart';
import 'package:udharo/data/repository/kyc_repository.dart';
import 'package:udharo/data/repository/user_repository.dart';
import 'package:udharo/service/borrow_history_bloc/borrow_history_bloc.dart';
import 'package:udharo/service/browse_borrow_requests_bloc/browse_borrow_request_bloc.dart';
import 'package:udharo/service/create_borrow_request_bloc/create_borrow_request_bloc.dart';
import 'package:udharo/service/payment_bloc/payment_bloc.dart';
import 'package:udharo/service/login_bloc/login_bloc.dart';
import 'package:udharo/service/register_bloc/register_bloc.dart';
import 'package:udharo/service/upload_kyc_bloc/upload_kyc_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/theme/theme_class.dart';
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
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            UserRepository(),
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            AuthRepository(),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            AuthRepository(),
          ),
        ),
        BlocProvider<CreateBorrowRequestBloc>(
          create: (context) => CreateBorrowRequestBloc(
            BorrowRepository(),
          ),
        ),
        BlocProvider<BrowseBorrowRequestBloc>(
          create: (context) => BrowseBorrowRequestBloc(
            BorrowRepository(),
            UserRepository(),
          ),
        ),
        BlocProvider<BorrowHistoryBloc>(
          create: (context) => BorrowHistoryBloc(
            BorrowRepository(),
          ),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(
            BorrowRepository(),
          ),
        ),
        BlocProvider<UploadKycBloc>(
          create: (context) => UploadKycBloc(
            KYCRepository(),
          ),
        ),
        BlocProvider<ViewKycBloc>(
          create: (context) => ViewKycBloc(
            KYCRepository(),
          ),
        ),
      ],
      child: KhaltiScope(
        publicKey: Config.khaltiTestPublicKey,
        builder: (context, navigatorKey) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            title: 'Udharo',
            debugShowCheckedModeBanner: false,
            theme: ThemeClass.defaultTheme,
            home:
                widget.isUserLoggedIn ? const HomePage() : const SignUpScreen(),
          );
        },
      ),
    );
  }
}
