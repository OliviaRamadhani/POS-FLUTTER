import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk konversi data JSON

class TransactionReportPage extends StatefulWidget {
  @override
  _TransactionReportPageState createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  late Future<List<Map<String, dynamic>>> futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = fetchTransactionReports(); // Mengambil laporan transaksi
  }

  // Mengambil data laporan transaksi langsung dari API
  Future<List<Map<String, dynamic>>> fetchTransactionReports() async {
    final response = await http.get(Uri.parse('http://192.168.2.102:8000/api/inventori/laporan'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data); // Mengubah JSON menjadi List<Map>
    } else {
      throw Exception('Gagal memuat laporan transaksi');
    }
  }

  // Menampilkan detail laporan
  void _showReportDetail(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Laporan Pembelian'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${report['id']}'),
              Text('Pembelian ID: ${report['pembelian_id']}'),
              Text('Status: ${report['status']}'),
              Text('Total Price: Rp ${report['total_price']}'),
              Text('Dibuat Pada: ${report['created_at']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup detail laporan
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                // Aksi Hapus Laporan
                _deleteReport(report['id']);
              },
              child: Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                // Aksi Export Excel
                _exportReport();
              },
              child: Text('Export ke Excel'),
            ),
          ],
        );
      },
    );
  }

  // Menghapus laporan
  void _deleteReport(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://192.168.2.102:8000/api/inventori/laporan/$id'));

      if (response.statusCode == 200) {
        setState(() {
          futureReports = fetchTransactionReports(); // Update data setelah dihapus
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil dihapus')));
        Navigator.pop(context); // Menutup dialog
      } else {
        throw Exception('Gagal menghapus laporan');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus laporan')));
    }
  }

  // Mengekspor laporan ke Excel
  void _exportReport() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.2.102:8000/api/inventori/laporan/export'));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil diekspor')));
      } else {
        throw Exception('Gagal mengekspor laporan');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengekspor laporan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Pembelian'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada laporan pembelian.'));
          }

          List<Map<String, dynamic>> reports = snapshot.data!;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text('Laporan Pembelian ID: ${report['pembelian_id']}'),
                subtitle: Text('Total: Rp ${report['total_price']}'),
                onTap: () => _showReportDetail(report), // Menampilkan detail saat ditekan
              );
            },
          );
        },
      ),
    );
  }
}
