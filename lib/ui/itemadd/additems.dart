import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';

class AddItems extends StatelessWidget {
  const AddItems({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      appBar: CustomAppBar(title: 'Add Items'),
      body: Center(
        child: Text('Add Items Content'),
      ),
    );
  }
}