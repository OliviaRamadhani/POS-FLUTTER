import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthApi {
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.2.102:8000/api/auth/login'), // Ganti dengan URL login API Laravel Anda
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        return User.fromJson(data['user']); // Mengonversi data JSON ke objek User
      }
    }
    return null;
  }
}
