import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';

class Suppliers extends StatelessWidget {
  const Suppliers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Suppliers'),
      body: Center(
        child: Text('Suppliers Content'),
      ),
    );
  }
}