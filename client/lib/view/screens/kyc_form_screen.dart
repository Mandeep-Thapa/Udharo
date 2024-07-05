import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udharo/service/upload_kyc_bloc/upload_kyc_bloc.dart';
import 'package:udharo/service/user_profile_bloc/profile_bloc.dart';
import 'package:udharo/view/screens/view_kyc_screen.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_image_selector_button.dart';
import 'package:udharo/view/widget/custom_toast.dart';

class KYCFormScreen extends StatefulWidget {
  const KYCFormScreen({super.key});

  @override
  State<KYCFormScreen> createState() => _KYCFormScreenState();
}

class _KYCFormScreenState extends State<KYCFormScreen> {
  final _formField = GlobalKey<FormState>();

  // text editing controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _citizenshipNumberController;
  late TextEditingController _panNumberController;

  String? _selectedGender;

  File? _citizenshipFrontPhoto;
  File? _citizenshipBackPhoto;
  File? _passportSizePhoto;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _citizenshipNumberController = TextEditingController();
    _panNumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _citizenshipNumberController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileStateError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is ProfileStateLoaded) {
            final user = state.user.data;

            // split the name into first name and last name
            final nameParts = user!.userName!.split(' ');
            final firstName = nameParts.isNotEmpty ? nameParts.first : '';
            final lastName =
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

            _firstNameController.text = firstName;
            _lastNameController.text = lastName;

            _phoneNumberController.text = user.phoneNumber.toString();

            // actual form fields
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formField,
                  child: Column(
                    children: [
                      // name fields
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // first name field
                          Expanded(
                            child: firstNameFormField(),
                          ),

                          const SizedBox(
                            width: 8.0,
                          ),

                          // last name field
                          Expanded(
                            child: lastNameFormField(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // phone number field
                      phoneNumberFormField(),
                      const SizedBox(
                        height: 20,
                      ),

                      // gender form field
                      genderFormField(),
                      const SizedBox(
                        height: 20,
                      ),

                      // citizenship number field
                      citizenshipNumberFormField(),
                      const SizedBox(
                        height: 20,
                      ),

                      // pan number field
                      panNumberFormField(),

                      const SizedBox(height: 20),

                      // citizenship photo fields
                      Row(
                        children: [
                          // citizenship front photo field
                          Expanded(
                            child: imageFormField(
                              _citizenshipFrontPhoto,
                              'Citizenship Front',
                            ),
                          ),

                          const SizedBox(width: 10),

                          // citizenship back photo field
                          Expanded(
                            child: imageFormField(
                              _citizenshipBackPhoto,
                              'Citizenship Back',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // passport size  photo field
                      imageFormField(
                        _passportSizePhoto,
                        'Passport size photo',
                      ),

                      const SizedBox(height: 50),

                      // submit button

                      BlocConsumer<UploadKycBloc, UploadKycState>(
                        listener: (context, state) {
                          if (state is UploadKycStateLoading) {
                            CustomToast().showToast(
                              context: context,
                              message: 'Submitting KYC...',
                            );
                          }
                          if (state is UploadKycStateSuccess) {
                            CustomToast().showToast(
                              context: context,
                              message: 'KYC submitted successfully',
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewKYCScreen(),
                              ),
                            );
                          } else if (state is UploadKycStateError) {
                            CustomToast().showToast(
                              context: context,
                              message:
                                  'KYC submission failed: ${state.message}',
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (_formField.currentState!.validate()) {
                                if (_citizenshipBackPhoto == null ||
                                    _citizenshipFrontPhoto == null ||
                                    _passportSizePhoto == null) {
                                  CustomToast().showToast(
                                    context: context,
                                    message:
                                        'Please upload all the required photos',
                                  );
                                  return;
                                }

                                // form is valid
                                // submit the form

                                context
                                    .read<UploadKycBloc>()
                                    .add(UploadKycEventSubmitKYC(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phoneNumber: int.parse(
                                          _phoneNumberController.text),
                                      gender: _selectedGender!,
                                      citizenshipNumber:
                                          _citizenshipNumberController.text
                                              .toString(),
                                      panNumber: (_panNumberController
                                              .text.isNotEmpty)
                                          ? _panNumberController.text.toString()
                                          : null,
                                      citizenshipFrontPhoto:
                                          _citizenshipFrontPhoto!,
                                      citizenshipBackPhoto:
                                          _citizenshipBackPhoto!,
                                      passportSizePhoto: _passportSizePhoto!,
                                    ));
                              }
                            },
                            child: const Text('Submit'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text('Error loading profile');
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  //  name validator
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.startsWith(RegExp(r'[0-9]'))) {
      return 'Name cannot start with a number';
    }
    bool nameValid = RegExp(r"^[a-zA-Z\-'. ]+$").hasMatch(value);
    if (!nameValid) {
      return "Enter a valid name";
    }
    return null;
  }

  // text form fields
  TextFormField firstNameFormField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: 'First Name  *',
      ),
      validator: nameValidator,
      readOnly: true,
    );
  }

  TextFormField lastNameFormField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name *',
      ),
      validator: nameValidator,
      readOnly: true,
    );
  }

  DropdownButtonFormField<String> genderFormField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender *',
        border: OutlineInputBorder(),
      ),
      value: _selectedGender,
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      items: <String>[
        'Male',
        'Female',
        'Other',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }

  TextFormField phoneNumberFormField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: const InputDecoration(
        labelText: 'Phone Number *',
      ),
      // validator: nameValidator,
      readOnly: true,
    );
  }

  TextFormField citizenshipNumberFormField() {
    return TextFormField(
      controller: _citizenshipNumberController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Citizenship Number *',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Citizenship number is required';
        }
        if (int.tryParse(value) == null) {
          return 'Citizenship number must be a number';
        }
        if (int.parse(value) < 0) {
          return 'Citizenship number must be a positive number';
        }
        if (int.parse(value) % 1 != 0) {
          return 'Citizenship number must be a whole number';
        }
        return null;
      },
    );
  }

  TextFormField panNumberFormField() {
    return TextFormField(
      controller: _panNumberController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Pan Number',
      ),
      validator: (value) {
        if (_panNumberController.text.isNotEmpty) {
          // only validate if the PAN number is not empty
          if (int.tryParse(value!) == null) {
            return 'Pan number must be a number';
          }
          if (int.parse(value) < 0) {
            return 'Pan number must be a positive number';
          }
          if (int.parse(value) % 1 != 0) {
            return 'Pan number must be a whole number';
          }
        }
        return null;
      },
    );
  }

  Stack imageFormField(
    File? image,
    String label,
  ) {
    return Stack(
      children: [
        if (image != null) Image.file(image),
        CustomImageSelectionButton(
          image: image,
          label: label,
          onPressed: (photo) {
            setState(
              () {
                if (label == 'Citizenship Front') {
                  _citizenshipFrontPhoto = photo;
                } else if (label == 'Citizenship Back') {
                  _citizenshipBackPhoto = photo;
                } else if (label == 'Passport size photo') {
                  _passportSizePhoto = photo;
                }
              },
            );
          },
        ),
      ],
    );
  }
}
