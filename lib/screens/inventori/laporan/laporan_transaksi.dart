import 'package:flutter/material.dart';
import 'package:pos2_flutter/services/transaction_report_api.dart'; // Import API
import 'package:pos2_flutter/models/transaction_report_model.dart'; // Import Model

class TransactionReportPage extends StatefulWidget {
  @override
  _TransactionReportPageState createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  late Future<List<TransactionReport>> futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = TransactionReportApi().fetchTransactionReports(); // Mengambil laporan transaksi
  }

  // Menampilkan detail laporan
  void _showReportDetail(TransactionReport report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Laporan Pembelian'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${report.id}'),
              Text('Pembelian ID: ${report.pembelianId}'),
              Text('Status: ${report.status}'),
              Text('Total Price: Rp ${report.totalPrice}'),
              Text('Dibuat Pada: ${report.createdAt}'),
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
                _deleteReport(report.id);
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
      await TransactionReportApi().deleteTransactionReport(id);
      setState(() {
        futureReports = TransactionReportApi().fetchTransactionReports(); // Update data setelah dihapus
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil dihapus')));
      Navigator.pop(context); // Menutup dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus laporan')));
    }
  }

  // Mengekspor laporan ke Excel
  void _exportReport() async {
    try {
      await TransactionReportApi().exportToExcel();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil diekspor')));
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
      body: FutureBuilder<List<TransactionReport>>(
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

          List<TransactionReport> reports = snapshot.data!;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text('Laporan Pembelian ID: ${report.pembelianId}'),
                subtitle: Text('Total: Rp ${report.totalPrice}'),
                onTap: () => _showReportDetail(report), // Menampilkan detail saat ditekan
              );
            },
          );
        },
      ),
    );
  }
}
