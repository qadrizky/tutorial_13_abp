import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorial_13_abp/model/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/product'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<Product?> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/product'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to add product: ${response.body}');
    }
  }
}
