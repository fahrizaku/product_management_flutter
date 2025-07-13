// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';
  static String get productsUrl => '$baseUrl/api/products';

  // Get all products
  static Future<List<Product>> getProducts() async {
    try {
      print('🔍 API Base URL: $baseUrl');
      print('🔍 Products URL: $productsUrl');

      final response = await http.get(Uri.parse(productsUrl));

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('🔍 Parsed data count: ${data.length}');
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Get single product
  static Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(Uri.parse('$productsUrl/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Create new product
  static Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(productsUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toApiJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create product');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  // Update product
  static Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$productsUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toApiJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // Delete product
  static Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$productsUrl/$id'));

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  // Get products with search and pagination
  static Future<Map<String, dynamic>> getProductsWithFilter({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
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
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        return {'products': products, 'pagination': data['pagination']};
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products with filter: $e');
    }
  }
}
