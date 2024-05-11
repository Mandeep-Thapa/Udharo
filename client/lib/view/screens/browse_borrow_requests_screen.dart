import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/browse_borrow_requests_bloc/browse_borrow_request_bloc.dart';
import 'package:udharo/service/payment_bloc/payment_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';
import 'package:udharo/view/widget/custom_dialog_box.dart';
import 'package:udharo/view/widget/custom_toast.dart';

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

                    // payment bloc
                    return BlocConsumer<PaymentBloc, PaymentState>(
                      listener: (context, state) {
                        if (state is PaymentStateKhaltiPaymentSuccess) {
                          // khalti payment success, accept borrow request
                          context.read<PaymentBloc>().add(
                                PaymentEventAcceptBorrowRequest(
                                  productIdentity: borrowRequest.id!,
                                ),
                              );
                        }
                        if (state is PaymentStateAcceptSuccess) {
                          // accept borrow request success
                          CustomToast().showToast(
                            context: context,
                            message: 'Borrow request accepted successfully.',
                          );

                          // reset payment bloc
                          context.read<PaymentBloc>().add(
                                PaymentEventResetPayment(),
                              );
                        }
                      },
                      builder: (context, state) {
                        return CustomDetailsContainer(
                          fields: [
                            Text('Borrower : ${borrowRequest.fullName}'),
                            Text('Purpose: ${borrowRequest.purpose}'),
                            Text('Amount: Rs.${borrowRequest.amount}'),
                            Text('Risk Factor: ${borrowRequest.riskFactor}'),
                            Text('Risk: ${borrowRequest.risk}'),
                            Text(
                                'Interest Rate: ${borrowRequest.interestRate}%'),
                            Text(
                                'Payback Period: ${borrowRequest.paybackPeriod} days'),
                          ],
                          showButton: true,
                          buttonName: 'Invest',
                          onPressed: () {
                            CustomDialogBox.showCustomDialogBox(
                              context,
                              'Invest in Borrow Request',
                              'Investing is a high-risk activity and may result in loss of funds. Are you sure you want to proceed?',
                              () {
                                context.read<PaymentBloc>().add(
                                      PaymentEventMakeKhaltiPayment(
                                        context: context,
                                        amount: borrowRequest.amount!,
                                        productIdentity: borrowRequest.id!,
                                        productName:
                                            'Loan for: ${borrowRequest.id!}',
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              buttonName: 'Invest',
                            );
                          },
                        );
                      },
                    );
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
