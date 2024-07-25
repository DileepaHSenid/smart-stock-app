import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80.0,
          elevation: 0.0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.rocket_launch), 
                label: 'Dashboard'),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.people),
              label: 'Suppliers',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle),
              label: 'Add',
            ),
          ],
        ),
      ),
      body:  Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    Container(color: Colors.green),
    Container(color: Colors.blue),
    Container(color: Colors.red),
    Container(color: Colors.yellow)
  ];
}
