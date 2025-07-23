// lib/services/api_service_product.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';
import 'token_service.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';
  static String get productsUrl => '$baseUrl/api/products';

  // Helper untuk mendapatkan headers dengan token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all products
  static Future<List<Product>> getProducts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(Uri.parse(productsUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Create new product
  static Future<Product> createProduct(Product product) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse(productsUrl),
        headers: headers,
        body: jsonEncode(product.toApiJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create product');
      }
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Update product
  static Future<Product> updateProduct(int id, Product product) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$productsUrl/$id'),
        headers: headers,
        body: jsonEncode(product.toApiJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  static Future<void> deleteProduct(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$productsUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Get single product by ID
  static Future<Product> getProduct(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$productsUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to fetch product');
      }
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  // Get products with search and pagination
  static Future<Map<String, dynamic>> getProductsWithFilter({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse(
        '$productsUrl/search',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        return {'products': products, 'pagination': data['pagination']};
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products with filter: $e');
    }
  }
}
