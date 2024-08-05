import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import 'card-add.dart';

class AddItems extends StatelessWidget {
  const AddItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Add Items'),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: const [
                  CardToAdd(
                      text: "Add Users to the System",
                      title: "Add User",
                      imageLink: "assets/images/navigator3.png",
                      navigationLink: "navlink"
                  ),
                  CardToAdd(
                      text: "Add products Which are new to the system",
                      title: "Add Products",
                      imageLink: "assets/images/navigator3.png",
                      navigationLink: "navlink"
                  ),
                  CardToAdd(
                      text: "Add Suppliers who are Supplying products",
                      title: "Add Suppliers",
                      imageLink: "assets/images/navigator3.png",
                      navigationLink: "navlink"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}