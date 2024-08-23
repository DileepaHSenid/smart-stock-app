import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardService {
  final String baseUrl;

  DashboardService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    final outOfStockResponse = await http.get(Uri.parse('$baseUrl/products/out-of-stock/count'));
    final lowInStockResponse = await http.get(Uri.parse('$baseUrl/products/low-in-stock/count'));
    final onDeliveryResponse = await http.get(Uri.parse('$baseUrl/products/on-delivery/count'));

    if (outOfStockResponse.statusCode == 200 &&
        lowInStockResponse.statusCode == 200 &&
        onDeliveryResponse.statusCode == 200) {
      return {
        'outOfStockProducts': json.decode(outOfStockResponse.body),
        'lowStockProducts': json.decode(lowInStockResponse.body),
        'onDeliveryProducts': json.decode(onDeliveryResponse.body),
      };
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }
}
