import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/data/repository/kyc_repository.dart';
import 'package:udharo/service/view_KYC_bloc/view_kyc_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';

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
        title: const Text('Browse Borrow Requests'),
      ),
      body: BlocBuilder<ViewKycBloc, ViewKycState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await KYCRepository().fetchKYC();
                  },
                  child: const Text('View KYC'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
