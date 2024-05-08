import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/browse_borrow_requests_bloc/browse_borrow_request_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';

class BrowseBorrowRequestsPage extends StatefulWidget {
  const BrowseBorrowRequestsPage({super.key});

  @override
  State<BrowseBorrowRequestsPage> createState() =>
      _BrowseBorrowRequestsPageState();
}

class _BrowseBorrowRequestsPageState extends State<BrowseBorrowRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Borrow Requests'),
      ),
      body: BlocBuilder<BrowseBorrowRequestBloc, BrowseBorrowRequestState>(
        builder: (context, state) {
          if (state is BrowseBorrowRequestStateInitial) {
            BlocProvider.of<BrowseBorrowRequestBloc>(context)
                .add(BrowseBorrowRequestEventLoadRequests());
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BrowseBorrowRequestStateLoaded) {
            final borrowRequests = state.borrowRequests.data?.borrowRequests;
            if (borrowRequests == null || borrowRequests.isEmpty) {
              return const Center(
                child: Text('No borrow requests found.'),
              );
            } else {
              return SizedBox(
                child: ListView.builder(
                  itemCount: borrowRequests.length,
                  itemBuilder: (context, index) {
                    final borrowRequest = borrowRequests[index];
                    return CustomDetailsContainer(
                      fields: [
                        Text('Borrower : ${borrowRequest.borrower}'),
                        Text('Purpose: ${borrowRequest.purpose}'),
                        Text('Amount: Rs.${borrowRequest.amount}'),
                        Text('Interest Rate: ${borrowRequest.interestRate}%'),
                        Text(
                            'Payback Period: ${borrowRequest.paybackPeriod} days'),
                      ],
                      showButton: true,
                      buttonName: 'Invest',
                      onPressed: () {
                        // handle button press
                        print(
                            'Button pressed for request: ${borrowRequest.id}');
                      },
                    );
                    // Column(
                    //   children: [
                    //     Text('Borrower : ${borrowRequest.borrower}'),
                    //     Text('Purpose: ${borrowRequest.purpose}'),
                    //     Text('Amount: Rs.${borrowRequest.amount}'),
                    //     Text('Interest Rate: ${borrowRequest.interestRate}%'),
                    //     Text(
                    //         'Payback Period: ${borrowRequest.paybackPeriod} days'),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //   ],
                    // );
                  },
                ),
              );
            }
          } else if (state is BrowseBorrowRequestStateError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Center(
              child: Text('Error fetching data. Please try again later.'),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
