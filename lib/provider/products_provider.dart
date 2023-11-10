import 'package:flutter/material.dart';
import '../api/products_service.dart';
import '../models/products_models.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService('https://dummyjson.com/products?limit=100');
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    try {
      _products = await _apiService.fetchProducts();
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
}