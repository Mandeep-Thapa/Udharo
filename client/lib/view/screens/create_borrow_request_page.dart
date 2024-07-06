import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/create_borrow_request_bloc/create_borrow_request_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/screens/home_page.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_toast.dart';

class CreateBorrowRequestPage extends StatefulWidget {
  const CreateBorrowRequestPage({super.key});

  @override
  State<CreateBorrowRequestPage> createState() =>
      _CreateBorrowRequestPageState();
}

class _CreateBorrowRequestPageState extends State<CreateBorrowRequestPage> {
  final _formField = GlobalKey<FormState>();

  // text editing controllers
  late TextEditingController _amountController;
  late TextEditingController _purposeController;
  late TextEditingController _interestRateController;
  late TextEditingController _paybackPeriodController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _purposeController = TextEditingController();
    _interestRateController = TextEditingController();
    _paybackPeriodController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    _interestRateController.dispose();
    _paybackPeriodController.dispose();
    super.dispose();
  }

  // submit the form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Borrow Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formField,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileStateInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfileStateError) {
                return Center(
                  child: Text('Error loading user profile: ${state.message}'),
                );
              } else if (state is ProfileStateLoaded) {
                final user = state.user.data;
              final isKycVerified = user?.isVerified?.isKycVerified ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // amount field
                    amountFormField(),
                    const SizedBox(
                      height: 20,
                    ),

                    // purpose field
                    purposeFormField(),
                    const SizedBox(
                      height: 20,
                    ),

                    // interest rate field
                    interestFormField(),
                    const SizedBox(
                      height: 20,
                    ),

                    // payback period field
                    paybackPeriodFormField(),

                    

                    const Spacer(),

                    BlocConsumer<CreateBorrowRequestBloc,
                        CreateBorrowRequestState>(
                      listener: (context, state) {
                        if (state is CreateBorrowRequestStateSuccess) {
                          // show success message
                          CustomToast().showToast(
                            context: context,
                            message:
                                'Your borrow request has been created successfully',
                          );

                          // clear the form fields
                          _amountController.clear();
                          _purposeController.clear();
                          _interestRateController.clear();
                          _paybackPeriodController.clear();

                          // clear bloc
                          BlocProvider.of<CreateBorrowRequestBloc>(context).add(
                            CreateBorrowRequestEventResetRequest(),
                          );

                          // navigate to home page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else if (state is CreateBorrowRequestStateError) {
                          // show error message

                          CustomToast().showToast(
                            context: context,
                            message:
                                'Error creating borrow request: ${state.message}',
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: (user != null &&
                                  user.hasActiveTransaction != null &&
                                  user.hasActiveTransaction! || !isKycVerified)
                              ? null
                              : () {
                                  if (_formField.currentState!.validate()) {
                                    // submit the form
                                    context.read<CreateBorrowRequestBloc>().add(
                                          CreateBorrowRequestEventSubmitRequest(
                                            amount: int.parse(
                                                _amountController.text),
                                            purpose: _purposeController.text,
                                            interestRate: double.parse(
                                                _interestRateController.text),
                                            paybackPeriod: int.parse(
                                                _paybackPeriodController.text),
                                          ),
                                        );
                                  }
                                },
                          child: ((user != null &&
                                  user.hasActiveTransaction != null) &&
                                  user.hasActiveTransaction!)
                              ? const Text(
                                  'Another transaction is already active',
                                )
                              :(isKycVerified)? 
                              const Text(
                                  'Create Borrow Request',
                                )
                                :const Text(
                                  'KYC not verified',
                                ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Error loading user profile'),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  // form fields
  TextFormField amountFormField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Amount',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Amount is required';
        }
        if (double.tryParse(value) == null) {
          return 'Amount must be a number';
        }
        if (double.parse(value) < 0) {
          return 'Amount must be a positive number';
        }
        if (double.parse(value) < 100) {
          return 'At least Rs. 100 is required to borrow';
        }
        if (double.parse(value) % 1 != 0) {
          return 'Amount must be a whole number';
        }
        return null;
      },
    );
  }

  TextFormField purposeFormField() {
    return TextFormField(
      controller: _purposeController,
      decoration: const InputDecoration(
        labelText: 'Purpose',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Purpose is required';
        }
        return null;
      },
    );
  }

  TextFormField interestFormField() {
    return TextFormField(
      controller: _interestRateController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Interest Rate (%)',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Interest Rate is required';
        }
        if (double.tryParse(value) == null) {
          return 'Interest Rate must be a number';
        }
        if (double.parse(value) < 0) {
          return 'Interest Rate must be a positive number';
        }
        if (double.parse(value) > 100) {
          return 'Interest Rate must be less than 100';
        }
        if (double.parse(value) < 1) {
          return 'Interest Rate must be at least 1%';
        }
        return null;
      },
    );
  }

  TextFormField paybackPeriodFormField() {
    return TextFormField(
      controller: _paybackPeriodController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Payback Period (days). Minimum 3 days.',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Payback Period is required';
        }
        if (int.tryParse(value) == null) {
          return 'Payback Period must be a number';
        }
        if (int.parse(value) < 3) {
          return 'Payback Period must be at least 3 days';
        }
        if (int.parse(value) > 365) {
          return 'Payback Period must be less than 365 days';
        }
        if (int.parse(value) % 1 != 0) {
          return 'Payback Period must be a whole number';
        }

        return null;
      },
    );
  }
}
