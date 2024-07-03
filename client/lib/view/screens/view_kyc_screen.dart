// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
// import 'package:udharo/view/widget/bottom_navigation_bar.dart';
// import 'package:udharo/view/widget/custom_details_container.dart';
// import 'package:udharo/view/widget/custom_image_with_label.dart';

// class ViewKYCScreen extends StatefulWidget {
//   const ViewKYCScreen({super.key});

//   @override
//   State<ViewKYCScreen> createState() => _ViewKYCScreenState();
// }

// class _ViewKYCScreenState extends State<ViewKYCScreen> {
//   _initialize() {
//     BlocProvider.of<ViewKycBloc>(context).add(ViewKycEventLoadKYC());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async{
//         _initialize();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('View KYC'),
//         ),
//         body: BlocBuilder<ViewKycBloc, ViewKycState>(
//           builder: (context, state) {
//             if (state is ViewKycStateInitial) {
//               BlocProvider.of<ViewKycBloc>(context).add(ViewKycEventLoadKYC());
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state is ViewKycStateError) {
//               if (state.message
//                   .toUpperCase()
//                   .contains(('KYC not found').toUpperCase())) {
//                 return const Center(
//                   child: Text('No KYC found'),
//                 );
//               } else {
//                 return Center(
//                   child: Text(state.message),
//                 );
//               }
//             } else if (state is ViewKycStateLoaded) {
//               final kycModel = state.kyc;
//               final kyc = kycModel.data;
//               if (kyc == null) {
//                 return const Center(
//                   child: Text('No KYC found.'),
//                 );
//               } else {
//                 return SingleChildScrollView(
//                   child: CustomDetailsContainer(
//                     fields: [
//                       Text('First Name : ${kyc.firstName}'),
//                       Text('Last Name: ${kyc.lastName}'),
//                       Text('Gender: ${kyc.gender}'),
//                       Text('Citizenship Number: ${kyc.citizenshipNumber}'),
//                       Text('Pan Number: ${kyc.panNumber ?? 'N/A'}'),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomImagewithLabel(
//                               label: 'Citizenship Back',
//                               imageUrl: kyc.citizenshipBackPhoto ?? '',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: CustomImagewithLabel(
//                               label: 'Citizenship Front',
//                               imageUrl: kyc.citizenshipFrontPhoto ?? '',
//                             ),
//                           ),
//                         ],
//                       ),
//                       CustomImagewithLabel(
//                         label: 'Photo',
//                         imageUrl: kyc.photo ?? '',
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             } else {
//               return const Center(
//                 child: Text('Error loading KYC. Please try again.'),
//               );
//             }
//           },
//         ),
//         bottomNavigationBar: const CustomBottomNavigationBar(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/theme/theme_class.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_image_with_label.dart';

class ViewKYCScreen extends StatefulWidget {
  const ViewKYCScreen({super.key});

  @override
  State<ViewKYCScreen> createState() => _ViewKYCScreenState();
}

class _ViewKYCScreenState extends State<ViewKYCScreen> {
  _initialize() {
    BlocProvider.of<ViewKycBloc>(context).add(ViewKycEventLoadKYC());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _initialize();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View KYC'),
        ),
        body: BlocBuilder<ViewKycBloc, ViewKycState>(
          builder: (context, state) {
            if (state is ViewKycStateInitial) {
              BlocProvider.of<ViewKycBloc>(context).add(ViewKycEventLoadKYC());
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ViewKycStateError) {
              if (state.message
                  .toUpperCase()
                  .contains(('KYC not found').toUpperCase())) {
                return const Center(
                  child: Text('No KYC found'),
                );
              } else {
                return Center(
                  child: Text(state.message),
                );
              }
            } else if (state is ViewKycStateLoaded) {
              final kycModel = state.kyc;
              final kyc = kycModel.data;
              if (kyc == null) {
                return const Center(
                  child: Text('No KYC found.'),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        color: ThemeClass().primaryColor,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        margin: const EdgeInsets.all(
                          16.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Photo:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  GestureDetector(
                                    onTap: () {
                                      _showFullScreenImage(context, kyc.photo!);
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
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${kyc.firstName ?? ''} ${kyc.lastName ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Gender: ${kyc.gender ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          kyc.isKycVerified ?? false
                                              ? Icon(Icons.check_circle,
                                                  color: ThemeClass()
                                                      .secondaryColor)
                                              : Icon(Icons.error,
                                                  color:
                                                      ThemeClass().errorColor),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            kyc.isKycVerified ?? false
                                                ? 'Verified'
                                                : 'Not Verified',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kyc.isKycVerified ?? false
                                                  ? ThemeClass().secondaryColor
                                                  : ThemeClass().errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              
                              const Divider(),
                              const SizedBox(height: 16.0),
                              Text(
                                'Citizenship Number: ${kyc.citizenshipNumber ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'PAN Number: ${kyc.panNumber ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showFullScreenImage(
                                          context,
                                          kyc.citizenshipFrontPhoto!,
                                        );
                                      },
                                      child: kyc.citizenshipFrontPhoto != null
                                          ? CustomImagewithLabel(
                                              imageUrl:
                                                  kyc.citizenshipFrontPhoto ??
                                                      '',
                                              label: 'Citizenship Front',
                                              height: 200,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showFullScreenImage(
                                            context, kyc.citizenshipBackPhoto!);
                                      },
                                      child: kyc.citizenshipBackPhoto != null
                                          ? CustomImagewithLabel(
                                              imageUrl:
                                                  kyc.citizenshipBackPhoto ??
                                                      '',
                                              label: 'Citizenship Back',
                                              height: 200,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Center(
                child: Text('Error loading KYC. Please try again.'),
              );
            }
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

void _showFullScreenImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(imageUrl),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}
