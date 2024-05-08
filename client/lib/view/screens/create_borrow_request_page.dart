import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/create_borrow_request_bloc/create_borrow_request_bloc.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // amount field
              amountFormField(),

              // purpose field
              purposeFormField(),

              // interest rate field
              interestFormField(),

              // payback period field
              paybackPeriodFormField(),

              const SizedBox(height: 16),

              BlocConsumer<CreateBorrowRequestBloc, CreateBorrowRequestState>(
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
                    onPressed: () {
                      if (_formField.currentState!.validate()) {
                        // submit the form
                        context.read<CreateBorrowRequestBloc>().add(
                              CreateBorrowRequestEventSubmitRequest(
                                amount: int.parse(_amountController.text),
                                purpose: _purposeController.text,
                                interestRate:
                                    double.parse(_interestRateController.text),
                                paybackPeriod:
                                    int.parse(_paybackPeriodController.text),
                              ),
                            );
                      }
                    },
                    child: const Text(
                      'Create Request',
                    ),
                  );
                },
              ),
            ],
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
