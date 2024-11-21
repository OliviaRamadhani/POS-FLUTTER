import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'dart:io';

class ProductApi {
  final String apiUrl = 'http://192.168.2.102:8000/api/inventori/produk';

  // Fetch all products (Read)
  Future<List<Product>> fetchProducts({int? per, int? page, String? search, String? category}) async {
    // Membuat query parameters jika ada filter
    Map<String, String> queryParams = {};
    if (per != null) queryParams['per'] = per.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (search != null) queryParams['search'] = search;
    if (category != null) queryParams['category'] = category;

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data']; // Parsing respons Laravel
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Create a new product
  Future<void> createProduct(Product product, {File? imageFile, required String token}) async {
    final uri = Uri.parse('$apiUrl/store');
    final request = http.MultipartRequest('POST', uri);

    // Tambahkan header Authorization
    request.headers['Authorization'] = 'Bearer $token';

    // Menambahkan data produk
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['is_sold_out'] = product.isSoldOut.toString();

    // Menambahkan file gambar jika ada
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image_url', imageFile.path));
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product, {File? imageFile, required String token}) async {
    final uri = Uri.parse('$apiUrl/${product.id}');
    final request = http.MultipartRequest('POST', uri);

    // Tambahkan header Authorization
    request.headers['Authorization'] = 'Bearer $token';

    // Menambahkan data produk
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['is_sold_out'] = product.isSoldOut.toString();

    // Menambahkan file gambar jika ada
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image_url', imageFile.path));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Delete a product
  Future<void> deleteProduct(int id, {required String token}) async {
    final uri = Uri.parse('$apiUrl/$id');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  // Toggle Sold Out
  Future<void> toggleSoldOut(int id, {required String token}) async {
    final uri = Uri.parse('$apiUrl/$id/toggle-sold-out');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle sold out status');
    }
  }
}
