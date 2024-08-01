class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080';
  static _AuthEndpoints authEndpoints = _AuthEndpoints();
}

class _AuthEndpoints {
  final String loginEmail = '/signin';
}