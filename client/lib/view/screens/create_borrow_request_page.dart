import 'package:flutter/material.dart';
import 'package:udharo/view/widget/bottom_navigation_bar.dart';

class CreateBorrowRequestPage extends StatefulWidget {
  const CreateBorrowRequestPage({super.key});

  @override
  State<CreateBorrowRequestPage> createState() =>
      _CreateBorrowRequestPageState();
}

class _CreateBorrowRequestPageState extends State<CreateBorrowRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Borrow Request'),
      ),
      body: Column(
        children: [],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
