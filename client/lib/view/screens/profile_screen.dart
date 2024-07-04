import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/theme/theme_class.dart';
import 'package:udharo/view/widget/custom_show_full_screen_image.dart';
import 'package:udharo/view/widget/custom_transaction_detail_container.dart';

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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ViewKycBloc, ViewKycState>(
                    builder: (context, state) {
                      if (state is ViewKycStateInitial) {
                        BlocProvider.of<ViewKycBloc>(context)
                            .add(ViewKycEventLoadKYC());
                        return const SizedBox.shrink();
                      } else if (state is ViewKycStateLoaded) {
                        final kyc = state.kyc.data;
                        if (kyc == null) {
                          return const SizedBox.shrink();
                        }
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              CustomShowFullScreenImage().showFullScreenImage(
                                context,
                                kyc.photo!,
                              );
                            },
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage: kyc.photo != null
                                  ? NetworkImage(
                                      kyc.photo!,
                                    )
                                  : const AssetImage(
                                      'assets/default_avatar.png',
                                    ) as ImageProvider,
                            ),
                          ),
                        );
                      } else if (state is ViewKycStateError) {
                        return const Center(
                          child: Text(
                            'Error loading KYC details',
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeClass().secondaryColor,
                          ThemeClass().primaryColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeClass().primaryColor.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome,',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user?.userName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              user?.email ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isFullyVerified
                                  ? 'Verified'
                                  : (!isPanVerified && isKYCVerified)
                                      ? 'KYC verified without PAN'
                                      : 'Not Verified',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Risk Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Risk Factor: ${user?.riskFactor ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Risk Level: ${user?.risk ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTransactionDetailsContainer(
                    role: user?.userRole ?? '',
                    user: user!,
                  ),
                ],
              ),
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
    );
  }
}
