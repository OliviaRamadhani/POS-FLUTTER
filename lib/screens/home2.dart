import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'package:intl/intl.dart'; // For formatting currency
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const Home2(),
    );
  }
}

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  bool isDarkMode = false;
  int totalOrders = 0;
  double pemasukan = 0.0;

  List<String> months = [];
  List<int> totalCustomers = [];

  // Fetch dashboard data from the Laravel API
  Future<void> fetchDashboardData() async {
    try {
      final dashboardResponse = await http.get(
        Uri.parse('http://192.168.2.102:8000/api/dashboard/data'),
      );
      final chartResponse = await http.get(
        Uri.parse('http://192.168.2.102:8000/api/reservations/customers-per-month'),
      );

      if (dashboardResponse.statusCode == 200) {
        final dashboardData = json.decode(dashboardResponse.body);
        setState(() {
          totalOrders = dashboardData['total_orders'];
          pemasukan = dashboardData['total_revenue'];
        });
      }

      if (chartResponse.statusCode == 200) {
        final chartData = json.decode(chartResponse.body);
        setState(() {
          months = List<String>.from(chartData['months']);
          totalCustomers = List<int>.from(chartData['total_customers']);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: [
                _buildMetricCard("Total Reservation", "0", Icons.people, Colors.orange),
                _buildMetricCard("Total Orders", "$totalOrders", Icons.shopping_cart, Colors.green),
              ],
            ),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildMetricCard(
                  "Pemasukan", 
                  "Rp ${NumberFormat("#,###").format(pemasukan)}", 
                  Icons.attach_money, 
                  Colors.purple
                ),
              ],
            ),

            const SizedBox(height: 16.0),
            const Text(
              "Revenue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildToggleButtons(),
            const SizedBox(height: 16.0),
            _buildRevenueChart(),
            const SizedBox(height: 16.0),
            const Text(
              "Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildToggleButtons(),
            const SizedBox(height: 16.0),
            _buildOrdersChart(),
            const SizedBox(height: 16.0),
            
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color iconColor) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Text(
                      months[index],
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          minX: 0,
          maxX: (months.isNotEmpty ? months.length - 1 : 4).toDouble(),
          minY: 0,
          maxY: (totalCustomers.isNotEmpty
                  ? totalCustomers.reduce((a, b) => a > b ? a : b)
                  : 5000)
              .toDouble(),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: totalCustomers
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                  .toList(),
              gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent]),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Mon");
                    case 1:
                      return const Text("Tue");
                    case 2:
                      return const Text("Wed");
                    default:
                      return const Text("");
                  }
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 8,
                  color: Colors.blue,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: Colors.green,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 7,
                  color: Colors.orange,
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildToggleButton("Monthly", true),
        _buildToggleButton("Weekly", false),
        _buildToggleButton("Today", false),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
