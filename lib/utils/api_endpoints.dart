class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080';
  static _AuthEndpoints authEndpoints = _AuthEndpoints();
}

class _AuthEndpoints {
  final String loginEmail = '/signin';
  final String getSuppliers = '/suppliers';
  final String postSuppliers = '/suppliers';
  final String deleteSupplier = '/suppliers';
  final String updateSupplier = '/suppliers';
  final String addUser = '/users';
  final String createUser = '/signup'; 
  final String getProducts = '/products';
}