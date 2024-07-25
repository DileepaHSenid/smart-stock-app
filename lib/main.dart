import 'package:flutter/material.dart';
import 'package:project/components/navbar.dart';
import 'package:project/ui/itemadd/additems.dart';
import 'package:project/ui/dashboard/dashboard.dart';
import 'package:project/ui/login/login.dart';
import 'package:project/ui/products/products.dart';
import 'package:project/ui/profile/profile.dart';
import 'package:project/ui/suppliers/suppliers.dart';
import 'package:project/ui/welcome/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Stock',
      theme: ThemeData(
        fontFamily: 'JetBrainsMono',
      ),
      home: const Welcome(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/nabvbar': (context) => const NavigationMenu(),
        '/login': (context) => const Login(),
        '/dashboard': (context) => const Dashboard(),
        '/profile': (context) => const Profile(),
        '/products': (context) => const Products(),
        '/suppliers': (context) => const Suppliers(),
        '/add': (context) => const AddItems(),
      },
    );
  }
}
