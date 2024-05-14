import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';

class ViewKYCScreen extends StatefulWidget {
  const ViewKYCScreen({super.key});

  @override
  State<ViewKYCScreen> createState() => _ViewKYCScreenState();
}

class _ViewKYCScreenState extends State<ViewKYCScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text('No KYC history found.'),
              );
            } else {
              return CustomDetailsContainer(
                fields: [
                  Text('First Name : ${kyc.firstName}'),
                  Text('Last Name: ${kyc.lastName}'),
                  Text('Gender: ${kyc.gender}'),
                  Text('Citizenship Number: ${kyc.citizenshipNumber}'),
                  Text('Pan Number: ${kyc.panNumber}'),
                ],
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
    );
  }
}
