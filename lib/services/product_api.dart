import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'dart:io';
import 'auth_api.dart'; // Untuk otentikasi token

class ProductApi {
  // Base URL untuk API produk
  final String apiUrl = 'http://192.168.2.102:8000/api/inventori/produk';

  /// *** Fetch all products (Read) ***
  ///
  /// Mengambil daftar produk dengan opsi filter.
  Future<List<Product>> fetchProducts({
    int? per,
    int? page,
    String? search,
    String? category,
  }) async {
    // Mempersiapkan parameter query
    Map<String, String> queryParams = {};
    if (per != null) queryParams['per'] = per.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (search != null) queryParams['search'] = search;
    if (category != null) queryParams['category'] = category;

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    // Memanggil API
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil produk.');
    }
  }

  /// *** Create a new product ***
  ///
  /// Membuat produk baru. Opsi file gambar disertakan.
  Future<void> createProduct(Product product, {File? imageFile}) async {
    final token = await _getAuthToken();

    final uri = Uri.parse('$apiUrl/store');
    final request = http.MultipartRequest('POST', uri);

    // Menambahkan header dan field
    _addCommonHeaders(request, token);
    _addProductFields(request, product);

    // Menambahkan file jika ada
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image_url', imageFile.path),
      );
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Gagal membuat produk.');
    }
  }

  /// *** Update an existing product ***
  ///
  /// Memperbarui data produk. Gambar bisa diperbarui jika diberikan.
  Future<void> updateProduct(Product product, {File? imageFile}) async {
    final token = await _getAuthToken();

    final uri = Uri.parse('$apiUrl/${product.id}');
    final request = http.MultipartRequest('POST', uri);

    // Menambahkan header dan field
    _addCommonHeaders(request, token);
    _addProductFields(request, product);

    // Menambahkan file jika ada
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image_url', imageFile.path),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui produk.');
    }
  }

  /// *** Delete a product ***
  ///
  /// Menghapus produk berdasarkan ID.
  Future<void> deleteProduct(int id) async {
    final token = await _getAuthToken();

    final uri = Uri.parse('$apiUrl/$id');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk.');
    }
  }

  /// *** Toggle Sold Out ***
  ///
  /// Mengubah status sold out produk.
  Future<void> toggleSoldOut(int id) async {
    final token = await _getAuthToken();

    final uri = Uri.parse('$apiUrl/$id/toggle-sold-out');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah status sold out.');
    }
  }

  /// *** Helper Methods ***

  // Mendapatkan token otentikasi
  Future<String> _getAuthToken() async {
    final token = await AuthApi().getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }
    return token;
  }

  // Menambahkan header umum ke dalam request
  void _addCommonHeaders(http.MultipartRequest request, String token) {
    request.headers['Authorization'] = 'Bearer $token';
  }

  // Menambahkan field produk ke dalam request
  void _addProductFields(http.MultipartRequest request, Product product) {
    request.fields['name'] = product.name;
    request.fields['price'] = product.price.toString();
    request.fields['is_sold_out'] = product.isSoldOut.toString();
  }
}
