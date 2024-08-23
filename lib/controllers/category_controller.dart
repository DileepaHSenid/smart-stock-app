import 'package:http/http.dart' as http;
import 'package:project/utils/api_endpoints.dart';
import 'dart:convert';

class CategoryController {
  final String _baseUrl = ApiEndpoints.baseUrl;

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl${ApiEndpoints.authEndpoints.getCategories}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['payload'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Future<List<SubCategory>> fetchSubCategories(String categoryId) async {
  //   final url = '$_baseUrl${ApiEndpoints.authEndpoints.getSubCategories(categoryId)}';
  //   print('Fetching subcategories from $url');
    
  //   final response = await http.get(Uri.parse(url));

  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
    
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body)['payload'] ?? [];
  //     return data.map((json) => SubCategory.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load subcategories');
  //   }
  // }

  Future<List<SubCategory>> fetchSubCategories(String categoryId) async {
  final url = '$_baseUrl${ApiEndpoints.authEndpoints.getSubCategories(categoryId)}';
  print('Fetching subcategories from $url');
  
  final response = await http.get(Uri.parse(url));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['payload'] ?? [];
    return data.map((json) => SubCategory.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load subcategories');
  }
  }

  Future<void> addCategory(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${ApiEndpoints.authEndpoints.addCategory}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'subCategories': [] 
        }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add category');
    }
  }

Future<void> addSubCategory(String categoryId, String name) async {
  final url = '$_baseUrl${ApiEndpoints.authEndpoints.addSubCategory(categoryId)}';
  print('Adding subcategory to $url');

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'subCategories': []   
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode != 200) {
    throw Exception('Failed to add subcategory');
  }
}


}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SubCategory {
  final String id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? '', // Provide a default empty string if `id` is null
      name: json['name'] ?? '', // Provide a default empty string if `name` is null
    );
  }
}