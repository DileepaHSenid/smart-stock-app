import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/api_endpoints.dart';

class LoginController {
  int? statusCode;
  String? message;
  String? error;

  Future<void> login(String username, String password) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.loginEmail}';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (kDebugMode) {
      print('Response body: $responseBody');
    }

    statusCode = responseBody['statusCode'];
    message = responseBody['message'];
    error = responseBody['error'];

    if (statusCode == 200) {
      if (kDebugMode) {
        print('Login success: $message');
      }
    } else {
      throw Exception('Failed to log in: $error');
    }
  }
}
