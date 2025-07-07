import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/package.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PackageService {
  Future<List<Package>> fetchPackages() async {
    final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
    print('DEBUG: fetchPackages using baseUrl: $baseUrl');
    final url = Uri.parse('$baseUrl/packages');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Package.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load packages');
    }
  }

  Future<Map<String, dynamic>> applyPromoCode({
    required String promoCode,
    required int quantity,
    required String productId,
  }) async {
    final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
    print('DEBUG: applyPromoCode using baseUrl: $baseUrl');
    final url = Uri.parse('$baseUrl/promo-codes/apply');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'promoCode': promoCode,
          'quantity': quantity,
          'productId': productId,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'discount': data['discountAmount'],
          'newTotal': data['newTotal'],
          'message': data['message'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid promo code',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }
}
