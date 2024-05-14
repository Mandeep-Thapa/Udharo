import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/service/borrow_history_bloc/borrow_history_bloc.dart';
import 'package:udharo/service/login_bloc/login_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/view/screens/sign_in_screen.dart';

class SignOutButton {
  TextButton signOutButton(
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () {
        // reset blocs
        BlocProvider.of<ProfileBloc>(context).add(
          ProfileEventResetProfile(),
        );
        BlocProvider.of<BorrowHistoryBloc>(context).add(
          BorrowHistoryEventResetHistory(),
        );
        BlocProvider.of<LoginBloc>(context).add(
          LoginEventResetLogin(),
        );

        BlocProvider.of<ViewKycBloc>(context).add(
          ViewKycEventResetKYC(),
        );

        // remove token from shared preference and navigate to login screen
        SharedPreferences.getInstance().then(
          (prefs) {
            prefs.remove('token');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          },
        );
      },
      child: const Text('Sign Out'),
    );
  }
}
