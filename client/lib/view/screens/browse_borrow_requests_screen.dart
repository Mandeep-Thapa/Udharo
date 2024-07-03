import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/constants/enums.dart';
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
  int? _selectedRiskFactor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invest in Borrow Requests',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // filter by risk factor
            child: Wrap(
              spacing: 8.0,
              children: [
                // all risk factors
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedRiskFactor == null,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedRiskFactor = null;
                    });
                  },
                ),
                // spread operator chips for each risk factor
                ...RiskFactor.values.map(
                  (riskFactor) {
                    final int riskValue =
                        RiskFactor.values.indexOf(riskFactor) + 1;
                    return ChoiceChip(
                      label: Text(
                        RiskFactorExtension(riskFactor).name,
                      ),
                      selected: _selectedRiskFactor == riskValue,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedRiskFactor = selected ? riskValue : null;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                BlocBuilder<BrowseBorrowRequestBloc, BrowseBorrowRequestState>(
              builder: (context, state) {
                if (state is BrowseBorrowRequestStateInitial) {
                  BlocProvider.of<BrowseBorrowRequestBloc>(context)
                      .add(BrowseBorrowRequestEventLoadRequests());
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is BrowseBorrowRequestStateLoaded) {
                  final borrowRequests =
                      state.borrowRequests.data?.borrowRequests;
                  final user = state.user.data;
                  final isKycVerified =
                      user?.isVerified?.isKycVerified ?? false;

                  if (borrowRequests == null || borrowRequests.isEmpty) {
                    return const Center(
                      child: Text('No borrow requests found.'),
                    );
                  }

                  // filter borrow requests by risk factor
                  final filteredBorrowRequests = _selectedRiskFactor == null
                      ? borrowRequests
                      : borrowRequests
                          .where((request) =>
                              request.riskFactor == _selectedRiskFactor)
                          .toList();

                  return BlocConsumer<PaymentBloc, PaymentState>(
                    listener: (context, state) {
                      if (state is PaymentStateAcceptSuccess) {
                        context.read<PaymentBloc>().add(
                              PaymentEventMakeKhaltiPayment(
                                context: context,
                                amount: state.amount,
                                productIdentity: state.borrowId,
                                productName: 'Loan for: ${state.borrowId}',
                              ),
                            );
                      } else if (state is PaymentStateKhaltiPaymentSuccess) {
                        context.read<PaymentBloc>().add(
                              PaymentEventVerifyKhaltiTransaction(
                                token: state.success.token,
                                amount: state.success.amount,
                              ),
                            );
                      } else if (state
                          is PaymentStateKhaltiPaymentVerificationSuccess) {
                        final verificationData = state.success.data;
                        if (verificationData != null) {
                          context.read<PaymentBloc>().add(
                                PaymentEventSaveKhaltiTransaction(
                                  idx: verificationData.idx!,
                                  amount: verificationData.amount!,
                                  senderName: verificationData.merchant!.name!,
                                  createdOn:
                                      verificationData.createdOn!.toString(),
                                  receiverName: verificationData.user!.name!,
                                  feeAmount: verificationData.feeAmount!,
                                ),
                              );
                        }
                      } else if (state
                          is PaymentStateKhaltiPaymentSaveKhaltiPaymentSuccess) {
                        CustomToast().showToast(
                          context: context,
                          message: 'Borrow request accepted successfully.',
                        );
                      } else if (state is PaymentStateError) {
                        CustomToast().showToast(
                          context: context,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, paymentState) {
                      return SizedBox(
                        child: ListView.builder(
                          itemCount: filteredBorrowRequests.length,
                          itemBuilder: (context, index) {
                            final borrowRequest = filteredBorrowRequests[index];

                            // display borrow request details
                            return CustomDetailsContainer(
                              fields: [
                                Text(
                                  'Borrower : ${borrowRequest.fullName}',
                                ),
                                Text(
                                  'Purpose: ${borrowRequest.purpose}',
                                ),
                                Text(
                                  'Amount: Rs.${borrowRequest.amount}',
                                ),
                                Text(
                                  'Risk Factor: ${borrowRequest.riskFactor}',
                                ),
                                Text(
                                  'Risk: ${borrowRequest.risk}',
                                ),
                                Text(
                                  'Interest Rate: ${borrowRequest.interestRate}%',
                                ),
                                Text(
                                  'Payback Period: ${borrowRequest.paybackPeriod} days',
                                ),
                              ],
                              showButton: true,
                              buttonName: (user != null &&
                                      user.hasActiveTransaction != null &&
                                      user.hasActiveTransaction!)
                                  ? 'Active Transaction Pending'
                                  : (!isKycVerified)
                                      ? 'Unverified KYC'
                                      : 'Invest',
                              onPressed: (user != null ||
                                      user?.hasActiveTransaction != null ||
                                      user!.hasActiveTransaction! ||
                                      !isKycVerified)
                                  ? null
                                  : () {
                                      _showInvestDialog(
                                        context,
                                        borrowRequest.amount ?? 0,
                                        borrowRequest.id ?? '',
                                      );
                                    },
                            );
                          },
                        ),
                      );
                    },
                  );
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
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  void _showInvestDialog(
    BuildContext context,
    int amount,
    String borrowId,
  ) {
    double minAmount = amount * 0.25;
    double maxAmount = amount * 0.40;
    double selectedAmount = minAmount;

    TextEditingController amountController =
        TextEditingController(text: selectedAmount.toInt().toString());
    FocusNode focusNode = FocusNode();

    CustomDialogBox.showCustomDialogBox(
      context,
      'Invest in Borrow Request',
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select the amount to invest (between ${minAmount.toInt()} and ${maxAmount.toInt()})',
              ),
              Slider(
                min: minAmount,
                max: maxAmount,
                divisions: (maxAmount - minAmount).toInt(),
                value: selectedAmount,
                label: selectedAmount.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    selectedAmount = value;
                    amountController.text = selectedAmount.toInt().toString();
                  });
                },
              ),
              Text(
                'Selected Amount: Rs. ${selectedAmount.toInt()}',
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                ),
                focusNode: focusNode,
                onChanged: (value) {},
                onEditingComplete: () {
                  double? inputAmount = double.tryParse(amountController.text);
                  if (inputAmount != null) {
                    if (inputAmount < minAmount) {
                      inputAmount = minAmount;
                    } else if (inputAmount > maxAmount) {
                      inputAmount = maxAmount;
                    }
                    setState(() {
                      selectedAmount = inputAmount!;
                      amountController.text = selectedAmount.toInt().toString();
                    });
                  }
                  focusNode.unfocus();
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Warning: Investing is a high-risk activity and may result in loss of funds. Please ensure you understand the risks involved before investing.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
      () {
        context.read<PaymentBloc>().add(
              PaymentEventAcceptBorrowRequest(
                amount: selectedAmount.toInt(),
                productIdentity: borrowId,
              ),
            );
        Navigator.of(context).pop();
      },
      buttonName: 'I understand the risks and want to invest',
    );
  }
}
