import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:project/controllers/user_controller.dart';


class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'ADMIN'; // Default role
  final AddUserController _controller = AddUserController(baseUrl: 'http://10.0.2.2:8080');

  void _signUpUser() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      _controller.signUpUser(username, password, _role, context);
    } else {
      Flushbar(
        message: 'Please fill in all fields',
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _role,
              items: ['ADMIN', 'MAINTAINER'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _role = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpUser,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}