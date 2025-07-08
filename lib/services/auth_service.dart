import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Signup failed',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Login failed',
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchDiamonds() async {
    final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
    print('Diamonds: baseUrl = ' + baseUrl);
    final url = Uri.parse('$baseUrl/products/');
    print('Diamonds: Fetching from URL: $url');
    try {
      final response = await http.get(url);
      print('Diamonds: Response status: ${response.statusCode}');
      print('Diamonds: Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          print('Diamonds: Loaded list with length [32m${data.length}[0m');
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['products'] is List) {
          print(
            'Diamonds: Loaded map with products list, length [32m${data['products'].length}[0m',
          );
          return List<Map<String, dynamic>>.from(data['products']);
        } else {
          print('Diamonds: Invalid data format');
        }
      } else {
        print('Diamonds: Failed to fetch, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Diamonds: Exception: $e');
    }
    return [];
  }
}
