import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/data/model/user_profile_model.dart';
import 'package:udharo/service/return_money_bloc/return_money_bloc.dart';
import 'package:udharo/theme/theme_class.dart';
import 'package:udharo/view/widget/custom_toast.dart';

class CustomTransactionDetailsContainer extends StatelessWidget {
  final String role;
  final Data user;

  const CustomTransactionDetailsContainer({
    super.key,
    required this.role,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeClass().primaryColor,
        border: Border.all(
            // color: ThemeClass().secondaryColor,
            ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetails(),
        ],
      ),
    );
  }

  Widget buildDetails() {
    const headerStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    const subHeaderStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    if (role.toUpperCase() == 'BORROWER') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are a borrower.',
            style: headerStyle,
          ),
          Text(
            'Return amount: Rs.${user.transactions?.first.returnAmount ?? 0}',
            style: subHeaderStyle,
          ),
          const SizedBox(
            height: 2.5,
          ),
          Text(
            'Interest Rate: ${user.transactions?.first.interestRate ?? 0}%',
          ),
          const SizedBox(
            height: 2.5,
          ),
          Text(
            'Payback Period: ${user.transactions?.first.paybackPeriod ?? 0} days',
          ),
          const SizedBox(
            height: 10,
          ),
          BlocConsumer<ReturnMoneyBloc, ReturnMoneyState>(
            listener: (context, state) {
              if (state is ReturnMoneyStateReturnSuccess) {
                BlocProvider.of<ReturnMoneyBloc>(context).add(
                  ReturnMoneyEventMakeKhaltiPayment(
                    context: context,
                    amount: user.transactions?.first.returnAmount?.toInt() ?? 0,
                    productIdentity: user.transactions?.first.transaction ?? '',
                    productName:
                        'return money for ${user.transactions?.first.borrowerName ?? ''}',
                  ),
                );
              }
              if (state is ReturnMoneyStateKhaltiPaymentSuccess) {
                BlocProvider.of<ReturnMoneyBloc>(context)
                    .add(ReturnMoneyEventVerifyKhaltiTransaction(
                  token: state.success.token,
                  amount: state.success.amount,
                ));
              }
              if (state is ReturnMoneyStateKhaltiVerificationSuccess) {
                final verificationData = state.success.data;
                if (verificationData != null) {
                  BlocProvider.of<ReturnMoneyBloc>(context).add(
                    ReturnMoneyEventSaveKhaltiTransaction(
                      idx: verificationData.idx!,
                      amount: verificationData.amount!,
                      senderName: verificationData.merchant!.name!,
                      createdOn: verificationData.createdOn!.toString(),
                      receiverName: verificationData.user!.name!,
                      feeAmount: verificationData.feeAmount!,
                    ),
                  );
                }
              }
              if(state is ReturnMoneyStatePaymentSaveSucess){
                CustomToast().showToast(
                  context: context,
                  message: 'Payment successful',
                );
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ReturnMoneyBloc>(context).add(
                    ReturnMoneyEventMakeReturnRequest(
                      amount:
                          user.transactions?.first.returnAmount?.toInt() ?? 0,
                      borrowId: user.transactions?.first.transaction ?? '',
                    ),
                  );
                },
                child: const Text(
                  'Return Money',
                ),
              );
            },
          ),
        ],
      );
    } else if (user.userRole?.toUpperCase() == 'LENDER') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are a lender.',
            style: headerStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Borrower name: ${user.transactions?.last.borrowerName ?? ''}',
            style: subHeaderStyle,
          ),
          Text(
            'Fulfilled Amount: ${user.transactions?.last.fulfilledAmount ?? 0}',
            style: subHeaderStyle,
          ),
          Text(
            'Return amount: Rs.${user.transactions?.last.returnAmount ?? 0}',
            style: subHeaderStyle,
          ),
          Text(
            'Expected Return Date: ${user.transactions?.last.expectedReturnDate ?? 'N/A'}',
            style: subHeaderStyle,
          ),
        ],
      );
    } else {
      return const Text(
        'You have no active transactions.',
        style: headerStyle,
      );
    }
  }
}
