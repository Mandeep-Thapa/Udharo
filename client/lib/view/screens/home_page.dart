import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/screens/kyc_form_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/sign_out_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(const ProfileEventLoadProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Udaro'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileStateLoaded) {
            final user = state.user.data;
            final hasActiveTransaction = user?.hasActiveTransaction ?? false;
            final isKycVerified = user?.isVerified?.isKycVerified ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // warning message if the user is not KYC verified
                (!isKycVerified)
                    ? GestureDetector(
                        onTap: () {
                          // navigate to the KYC verification screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KYCFormScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 30,
                          // color: Colors.red,
                          alignment: Alignment.center,
                          child: const Text(
                            'Your KYC is not verified. Please verify your KYC.',
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

                // display user name
                Text(
                  'Hello ${user?.userName ?? 'User'}',
                ),
                Text(
                  'You have ${hasActiveTransaction ? 1 : 0} active transactions.',
                ),

                // this button is for testing purpose
                TextButton(
                  onPressed: () async {},
                  child: const Text('Test'),
                ),
              ],
            );
          } else if (state is ProfileStateError) {
            if (state.message
                .toUpperCase()
                .contains(('Unauthorized: Please login again').toUpperCase())) {
              return const Center(
                child: Text('Session expired. Please login again.'),
              );
            } else {
              return Center(
                child: Text(state.message),
              );
            }
          } else {
            return const Center(
              child: Text('Profile could not be loaded. Please try again.'),
            );
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // check if the state is not an error, then show the bottom navigation bar
          if (state is! ProfileStateError) {
            return const CustomBottomNavigationBar();
          } else {
            return SignOutButton().signOutButton(context);
          }
        },
      ),
    );
  }
}
