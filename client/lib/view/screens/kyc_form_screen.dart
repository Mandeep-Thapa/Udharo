import 'dart:io';
import 'package:flutter/material.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';
import 'package:udharo/view/widget/custom_image_selector_button.dart';

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
    _citizenshipNumberController = TextEditingController();
    _panNumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
      body: SingleChildScrollView(
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

                    const SizedBox(width: 10),

                    // last name field
                    Expanded(
                      child: lastNameFormField(),
                    ),
                  ],
                ),

                // gender form field
                genderFormField(),

                // citizenship number field
                citizenshipNumberFormField(),

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

                const SizedBox(height: 20),

                // submit button
                ElevatedButton(
                  onPressed: () {
                    if (_formField.currentState!.validate()) {
                      // submit the form
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
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
    );
  }

  TextFormField lastNameFormField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name *',
      ),
      validator: nameValidator,
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
      controller: _citizenshipNumberController,
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

  Column imageFormField(
    File? image,
    String label,
  ) {
    return Column(
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
