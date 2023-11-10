import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/products_models.dart';

class ApiService {
  final String apiUrl;

  ApiService(this.apiUrl);

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('API Response: $data');
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }
}