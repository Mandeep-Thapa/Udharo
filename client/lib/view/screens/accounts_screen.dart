import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/screens/change_password_screen.dart';
import 'package:udharo/view/screens/kyc_form_screen.dart';
import 'package:udharo/view/screens/profile_screen.dart';
import 'package:udharo/view/screens/settings_page.dart';
import 'package:udharo/view/screens/view_kyc_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_settings_option.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              // navigate to home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileStateInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileStateError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is ProfileStateLoaded) {
              final user = state.user.data;
              final isKycVerified = user?.isVerified?.isKycVerified ?? false;

              return Column(
                children: [
                  const CustomSettingsOption(
                    icon: Icons.person,
                    title: 'Profile',
                    widget: ProfilePage(),
                  ),
                  !isKycVerified
                      ? const CustomSettingsOption(
                          icon: Icons.update,
                          title: 'Fill KYC',
                          widget: KYCFormScreen(),
                        )
                      : const SizedBox.shrink(),
                  const CustomSettingsOption(
                    icon: Icons.subtitles,
                    title: 'View KYC',
                    widget: ViewKYCScreen(),
                  ),

                  const CustomSettingsOption(
                    icon: Icons.edit,
                    title: 'Change Password',
                    widget: ChangePasswordScreen(),
                  ),
                  const Spacer(),
                ],
              );

              
            } else {
              return const Center(
                child: Text(
                    'Profile could not be loaded. Please try again later.'),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
