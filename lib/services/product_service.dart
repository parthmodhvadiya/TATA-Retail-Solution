import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Try different URLs based on the platform
  static String get baseUrl {
    // For Android emulator
    // return 'http://10.0.2.2:5000/api/products';

    // For iOS simulator
    // return 'http://localhost:5000/api/products';

    // For physical device (replace with your computer's IP address)
    return 'http://localhost:5000/api/products';
  }

  Future<List<Product>> getProducts() async {
    try {
      print('Attempting to fetch products from: $baseUrl');
      final response = await http.get(Uri.parse(baseUrl));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      print('Attempting to fetch product from: $baseUrl/$id');
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getProductById: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      print('Attempting to create product at: $baseUrl');
      print('Product data: ${product.toJson()}');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(product.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to create product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in createProduct: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    try {
      print('Attempting to update product at: $baseUrl/$id');
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(product.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to update product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in updateProduct: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      print('Attempting to delete product at: $baseUrl/$id');
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in deleteProduct: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
}
