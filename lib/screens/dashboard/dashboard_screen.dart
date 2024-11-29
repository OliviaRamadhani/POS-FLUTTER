import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalSales = 0;
  int totalReservations = 0;
  int totalCustomers = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch data dari API
  Future<void> fetchData() async {
    try {
      final totalSalesResponse = await http.get(Uri.parse('http://localhost:8000/api/totalsales'));
      final totalReservationsResponse = await http.get(Uri.parse('http://localhost:8000/api/reservations/count'));
      final totalCustomersResponse = await http.get(Uri.parse('http://localhost:8000/api/total-customers'));

      setState(() {
        totalSales = json.decode(totalSalesResponse.body)['totalSales'];
        totalReservations = json.decode(totalReservationsResponse.body)['totalItems'];
        totalCustomers = json.decode(totalCustomersResponse.body)['total_customers'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Fungsi format mata uang
  String formatCurrency(double value) {
    return 'IDR ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard('Total Sales', formatCurrency(totalSales), Icons.attach_money),
                _statCard('Total Reservations', totalReservations.toString(), Icons.event),
                _statCard('Total Customers', totalCustomers.toString(), Icons.people),
              ],
            ),
            SizedBox(height: 20),
            // Grafik
            Text('Customer Over Time', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 4,
                  minY: 0,
                  maxY: 5000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1200),
                        FlSpot(1, 1900),
                        FlSpot(2, 3000),
                        FlSpot(3, 5000),
                        FlSpot(4, 4200),
                      ],
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
