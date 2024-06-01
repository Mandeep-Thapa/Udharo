import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';
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
      onRefresh: () async{
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
                  child: CustomDetailsContainer(
                    fields: [
                      Text('First Name : ${kyc.firstName}'),
                      Text('Last Name: ${kyc.lastName}'),
                      Text('Gender: ${kyc.gender}'),
                      Text('Citizenship Number: ${kyc.citizenshipNumber}'),
                      Text('Pan Number: ${kyc.panNumber ?? 'N/A'}'),
                      Row(
                        children: [
                          Expanded(
                            child: CustomImagewithLabel(
                              label: 'Citizenship Back',
                              imageUrl: kyc.citizenshipBackPhoto ?? '',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomImagewithLabel(
                              label: 'Citizenship Front',
                              imageUrl: kyc.citizenshipFrontPhoto ?? '',
                            ),
                          ),
                        ],
                      ),
                      CustomImagewithLabel(
                        label: 'Photo',
                        imageUrl: kyc.photo ?? '',
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
