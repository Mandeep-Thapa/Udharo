import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/screens/borrow_history_screen.dart';
import 'package:udharo/view/screens/browse_borrow_requests_screen.dart';
import 'package:udharo/view/screens/create_borrow_request_page.dart';
import 'package:udharo/view/screens/kyc_form_screen.dart';
import 'package:udharo/view/screens/profile_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_image_with_label.dart';
import 'package:udharo/view/widget/custom_transaction_detail_container.dart';
import 'package:udharo/view/widget/custom_warning_container.dart';
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
        title: const Text(
          'Home',
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
            ),
            onPressed: () {
              // navigate to View Account screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              if (state.message.toUpperCase().contains(
                  ('Unauthorized: Please login again').toUpperCase())) {
                return const Center(
                  child: Text('Session expired. Please login again.'),
                );
              } else {
                return Center(
                  child: Text(state.message),
                );
              }
            } else if (state is ProfileStateLoaded) {
              final user = state.user.data;
              final hasActiveTransaction = user?.hasActiveTransaction ?? false;
              final isKycVerified = user?.isVerified?.isKycVerified ?? false;
              if (user == null) {
                return const Center(
                  child: Text('User can not be loaded. Please try again.'),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // warning message if the user is not KYC verified
                  !isKycVerified
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
                          child: const CustomWarningContainer(
                            message:
                                'You have not verified your KYC. Please Click here to verify your KYC and perform transactions.',
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hello, ${(user.userName ?? 'User')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You have ${(hasActiveTransaction ? 'an' : 'no')} active transaction${(hasActiveTransaction ? '' : 's')}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Add Funds',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Payback',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      // navigate to Borrow Request History screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BorrowHistoryScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'View My Transactions',
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    'Active Transactions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // display information user role
                  CustomTransactionDetailsContainer(
                    role: user.userRole ?? '',
                    user: user,
                  ),

                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // navigate to Browse Borrow Request screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BrowseBorrowRequestsPage(),
                              ),
                            );
                          },
                          child: const Column(
                            children: [
                              CustomImagewithLabel(
                                imageUrl: 'lib/assets/cash1.jpg',
                                label: 'Invest Money',
                                isnetworkImage: false,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // navigate to Create Borrow Request screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateBorrowRequestPage(),
                              ),
                            );
                          },
                          child: const Column(
                            children: [
                              CustomImagewithLabel(
                                imageUrl: 'lib/assets/cash2.jpg',
                                label: 'Request Loan',
                                isnetworkImage: false,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Profile could not be loaded. Please try again.'),
              );
            }
          },
        ),
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
