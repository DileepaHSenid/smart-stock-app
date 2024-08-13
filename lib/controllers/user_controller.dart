import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;

class AddUserController {
  final String baseUrl;

  AddUserController({required this.baseUrl});

  Future<void> signUpUser(String username, String password, String role, BuildContext context) async {
    final url = Uri.parse('$baseUrl/signup');

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {
      "username": username,
      "password": password,
      "role": role.toUpperCase() // Ensure role is uppercase as per enum
    };

    try {
      final response = await http.post(url, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['statusCode'] == 200) {
          Flushbar(
            message: 'User has been registered successfully',
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          )..show(context);
          // Close the page and return to the previous one
          Navigator.pop(context);
        } else {
          Flushbar(
            message: responseData['message'] ?? 'Failed to register user',
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
          )..show(context);
        }
      } else {
        Flushbar(
          message: 'Failed to register user',
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
        )..show(context);
      }
    } catch (error) {
      Flushbar(
        message: 'An error occurred. Please try again later.',
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red,
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
      )..show(context);
    }
  }
}