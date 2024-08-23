import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:project/utils/api_endpoints.dart';

class AddUserController {
  final String baseUrl;
  String? status;
  String? message;

  AddUserController({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.getUsers}';
    print('Making request to $url');  
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response status: ${response.statusCode}');  
      print('Response body: ${response.body}'); 

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      status = responseBody['status'];
      message = responseBody['message'];
      final List<dynamic> payload = responseBody['payload'];

      if (status == 'S0000' && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(payload.map((user) => {
              'id': user ['id'],
              'username': user['username'],
              'role': user['role'],
            }));
      } else {
        throw Exception('Failed to load users: $message');
      }
    } catch (e) {
      print('Error: $e');  
      rethrow;
    }
  }

  Future<bool> deleteUser(String userId) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.deleteUser}/$userId';
    print('Making DELETE request to $url');  
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        status = responseBody['status'];
        message = responseBody['message'];

        if (status == 'S0000') {
          return true;
        } else {
          throw Exception('Failed to delete user: $message');
        }
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have permission to delete this user.');
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting user: $e'); 
      rethrow;
    }
  }

  Future<void> signUpUser(String username, String password, String role, BuildContext context) async {
    final url = Uri.parse('$baseUrl/signup');

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {
      "username": username,
      "password": password,
      "role": role.toUpperCase() 
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

  Future<bool> updateUser(Map<String, dynamic> user) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.updateUser}/${user['id']}';
    print('Making PUT request to $url'); 
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user),
      );
      print('Response status: ${response.statusCode}');  
      print('Response body: ${response.body}');  

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        status = responseBody['status'];
        message = responseBody['message'];

        if (status == 'S0000') {
          return true;
        } else {
          throw Exception('Failed to update user: $message');
        }
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have permission to update this user.');
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user: $e'); 
      rethrow;
    }
  }
}