import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_report_model.dart';
import 'auth_api.dart'; // Import AuthService

class TransactionReportApi {
  final String apiUrl = 'http://192.168.2.102:8000/api/laporan-transaksi'; // Update with correct endpoint

  // Fetch all transaction reports (Read)
  Future<List<TransactionReport>> fetchTransactionReports({int? per, int? page, String? search}) async {
    Map<String, String> queryParams = {};
    if (per != null) queryParams['per'] = per.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => TransactionReport.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch transaction reports');
    }
  }

  // Update transaction status
  Future<void> updateTransactionStatus(int id, bool created) async {
    final token = await AuthApi().getToken(); // Fetch token from SharedPreferences
    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$apiUrl/update-status/$id');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'created': created.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction status');
    }
  }

  // Hapus laporan transaksi
  Future<void> deleteTransactionReport(int id) async {
    final token = await AuthApi().getToken(); // Ambil token dari SharedPreferences
    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$apiUrl/$id');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction report');
    }
  }


  // Export transaction report to Excel
  Future<void> exportToExcel() async {
    final token = await AuthApi().getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$apiUrl/export');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to export transaction report');
    }

    // Handle export logic here if needed
  }
}
