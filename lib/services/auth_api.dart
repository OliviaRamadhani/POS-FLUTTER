import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthApi {
  final String apiUrl = 'http://192.168.2.102:8000/api/auth';


  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'), // Ganti dengan URL login API Laravel Anda
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        final token = data['token']; // Mengambil token dari respons
        await _saveToken(token); // Simpan token ke SharedPreferences
        return User.fromJson(data['user']); // Mengonversi data JSON ke objek User
      }
    }
    return null;
  }

  // Fungsi untuk email
  Future<bool> sendOtpToEmail(String email, String name) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register/get/email/otp'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'name': name}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status']; // Mengembalikan status OTP berhasil atau tidak
    }
    return false;
  }

  Future<User?> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    String otpEmail,
  ) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'otp_email': otpEmail,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<void> submitCredentials(String name, String email, String phone) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: {'name': name, 'email': email, 'phone': phone},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit credentials');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register/check/email/otp'),
      body: {'email': email, 'otp': otp},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP');
    }
  }

  Future<void> submitPassword(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to set password');
    }
  }


  // Fungsi untuk menyimpan token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Fungsi untuk mendapatkan token yang tersimpan
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Token: $token'); // Tambahkan log
    return token;
  }

  // Fungsi untuk menyimpan data user
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Fungsi untuk mendapatkan data user
  Future<User?> getUser(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Fungsi untuk memperbarui profil pengguna
  Future<User?> updateUser({
    required String name,
    required String address,
    required String email,
    required String phone,
    File? photo,
    }) async {
      final token = await getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.2.102:8000/api/profile/update'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['email'] = email;
      request.fields['phone'] = phone;

      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        if (data['success']) {
          await saveUser(User.fromJson(data['user'])); // Update user lokal
          return User.fromJson(data['user']);
        }
      }
      return null;
  }
  

  // Fungsi untuk logout (menghapus token dan data user)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');  // Menghapus token
    await prefs.remove('user');   // Menghapus data user
  }

}


  