import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/borrow_history_bloc/borrow_history_bloc.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_details_container.dart';

class BorrowHistoryScreen extends StatefulWidget {
  const BorrowHistoryScreen({super.key});

  @override
  State<BorrowHistoryScreen> createState() => _BorrowHistoryScreenState();
}

class _BorrowHistoryScreenState extends State<BorrowHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Borrow Requests'),
      ),
      body: BlocBuilder<BorrowHistoryBloc, BorrowHistoryState>(
        builder: (context, state) {
          if (state is BorrowHistoryStateInitial) {
            BlocProvider.of<BorrowHistoryBloc>(context)
                .add(BorrowHistoryEventLoadHistory());
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BorrowHistoryStateError) {
            if (state.message
                .toUpperCase()
                .contains(('history does not exist').toUpperCase())) {
              return const Center(
                child: Text('No history found'),
              );
            } else {
              return Center(
                child: Text(state.message),
              );
            }
          } else if (state is BorrowHistoryStateLoaded) {
            final borrowHistory = state.borrowHistory;
            if (borrowHistory.isEmpty) {
              return const Center(
                child: Text('No borrow history found.'),
              );
            } else {
              return SizedBox(
                child: ListView.builder(
                  itemCount: borrowHistory.length,
                  itemBuilder: (context, index) {
                    final borrow = borrowHistory[index];
                    return CustomDetailsContainer(
                      fields: [
                        Text('Borrower : ${borrow.fullName}'),
                        Text('Purpose: ${borrow.purpose}'),
                        Text('Amount: Rs.${borrow.amount}'),
                        Text('Status: ${borrow.status}'),
                        Text('Interest Rate: ${borrow.interestRate}%'),
                        Text('Payback Period: ${borrow.paybackPeriod} days'),
                      ],
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text('Error loading borrow history. Please try again.'),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
