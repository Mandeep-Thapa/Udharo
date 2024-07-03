import 'package:flutter/material.dart';
import 'package:udharo/data/model/user_profile_model.dart';
import 'package:udharo/theme/theme_class.dart';

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
            'Return amount: ${user.transactions?.first.returnAmount ?? 0}',
            style: subHeaderStyle,
          ),
          
          const SizedBox(
            height: 2.5,
          ),

          Text(
            'Interest Rate: ${user.transactions?.first.interestRate ?? 0}',
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
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Return Money',
            ),
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
            'Borrower name: ${user.transactions?.first.borrowerName ?? ''}',
            style: subHeaderStyle,
          ),
          Text(
            'Fulfilled Amount: ${user.transactions?.first.fulfilledAmount ?? 0}',
            style: subHeaderStyle,
          ),
          Text(
            'Return amount: ${user.transactions?.first.returnAmount ?? 0}',
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
