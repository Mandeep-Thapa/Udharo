import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';
import 'package:udharo/view/widget/sign_out_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileStateLoaded) {
            final user = state.user.data;
            final isKYCVerified = user?.isVerified?.isKycVerified ?? false;
            final isPanVerified = user?.isVerified?.isPanVerified ?? false;
            final isFullyVerified = isKYCVerified && isPanVerified;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDetailsContainer(
                  fields: [
                    Text('Name : ${user?.userName ?? 'N/A'}'),
                    Text('Email: ${user?.email ?? 'N/A'}'),
                    Text(
                      'Verification Status: ${isFullyVerified ? 'Verified' : (!isPanVerified && isKYCVerified) ? 'KYC verified without PAN' : 'Not Verified'}',
                    ),
                    Text('risk: ${user?.risk ?? 'N/A'}'),
                  ],
                )
              ],
            );
          } else if (state is ProfileStateError) {
            return Center(
              child: Text(state.message),
            );
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
