import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/utils/api_endpoints.dart';

class SuppliersController {
  String? status;
  String? message;

  Future<List<Map<String, dynamic>>> fetchSuppliers() async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.getSuppliers}';
    print('Making request to $url');  // Debugging statement
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response status: ${response.statusCode}');  // Debugging statement
      print('Response body: ${response.body}');  // Debugging statement

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      status = responseBody['status'];
      message = responseBody['message'];
      final List<dynamic> payload = responseBody['payload'];

      if (status == 'S0000' && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(payload.map((supplier) => {
              'id': supplier['id'],
              'firstName': supplier['firstName'],
              'lastName': supplier['lastName'],
              'contactPerson': supplier['contactPerson'],
              'email': supplier['email'],
              'phone': supplier['phone'],
              'address': supplier['address'],
            }));
      } else {
        throw Exception('Failed to load suppliers: $message');
      }
    } catch (e) {
      print('Error: $e');  // Debugging statement
      rethrow;
    }
  }
}

