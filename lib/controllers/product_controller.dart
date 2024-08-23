import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/utils/api_endpoints.dart';

class ProductController {
  String? status;
  String? message;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.getProducts}';
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
        return List<Map<String, dynamic>>.from(payload.map((product) => {
          'id': product['id'],
          'name': product['name'],
          'status': product['status'],
          'ShippingId': product['ShippingId'],
          'description': product['description'],
          'price': product['price'],
          'quantityInStock': product['quantityInStock'],
          'categoryId': product['categoryId'],
          'supplierID': product['supplierID'],
        }));
      } else {
        throw Exception('Failed to load products: $message');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchProductById(String productId) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.getProductById}';
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
      final Map<String, dynamic> payload = responseBody['payload'];

      if (status == 'S0000' && response.statusCode == 200) {
        return payload;
      } else {
        throw Exception('Failed to load product: $message');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> addProduct(Map<String, dynamic> productData) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.addProduct}';
    print('Making request to $url');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productData),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      status = responseBody['status'];
      message = responseBody['message'];

      if (status == 'S0000' && response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add product: $message');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

Future<bool> deleteProduct(String productId) async {
  final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.deleteProduct(productId)}';
  print('Making request to $url');

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final String status = responseBody['status'];
    final String message = responseBody['message'];

    if (status == 'S0000' && response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product: $message');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchDashboardData() async {
  final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.getProducts}/dashboard';
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
    final Map<String, dynamic>? payload = responseBody['payload']; 

    if (status == 'S0000' && response.statusCode == 200) {
      if (payload != null) {
        return payload;
      } else {
        throw Exception('Received empty payload');
      }
    } else {
      throw Exception('Failed to load dashboard data: $message');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
}