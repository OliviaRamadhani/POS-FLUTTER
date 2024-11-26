import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart'; // Import AuthService untuk token autentikasi

class OrderApi {
  final String apiUrl = 'http://192.168.2.102:8000/api/orders';

  // Fungsi untuk mendapatkan informasi detail order berdasarkan UUID
  Future<Map<String, dynamic>> getOrderDetails(String uuid) async {
    final token = await AuthApi().getToken(); // Ambil token autentikasi
    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$apiUrl/show/$uuid');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch order details');
    }
  }

  // Fungsi untuk membuat pembayaran dengan UUID order
  Future<Map<String, dynamic>> createPayment(String uuid) async {
    final token = await AuthApi().getToken(); // Ambil token autentikasi
    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$apiUrl/checkout/$uuid');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create payment');
    }
  }
}
