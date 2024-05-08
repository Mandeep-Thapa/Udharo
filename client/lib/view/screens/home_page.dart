import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';

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
            return Column(
              children: [
                // display user name
                Text(
                  'Hello ${state.user.data?.userName ?? 'User'}',
                ),

                // this button is for testing purpose
                // TextButton(
                //   onPressed: () async {

                //   },
                //   child: const Text('Test'),
                // ),
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
