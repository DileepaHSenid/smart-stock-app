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
          'status': product['Status'],
          'ShippingId': product['ShippingId'],
          'description': product['description'],
          'price': product['price'],
          'stockQuantity': product['stockQuantity'],
          'categoryId': product['categoryId'],
          'supplierId': product['supplierId'],
        }));
      } else {
        throw Exception('Failed to load suppliers: $message');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  deleteProduct(String productId) {}
}