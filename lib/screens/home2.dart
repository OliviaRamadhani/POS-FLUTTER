import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home2(),
    );
  }
}

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'DASHBOARD',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.light_mode, color: Colors.black),
            onPressed: () {
              // Handle theme toggle here
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 16.0),
            // Top Metrics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricCard("Total Menus", "120", ""),
                _buildMetricCard("Total Orders", "180", ""),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricCard("Total Users", "240", ""),
                _buildMetricCard("Revenue", "140", ""),
              ],
            ),
            const SizedBox(height: 16.0),
            // Revenue Chart Section
            const Text(
              "Revenue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildToggleButtons(),
            const SizedBox(height: 16.0),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(child: Text("Revenue Chart Placeholder")),
            ),
            const SizedBox(height: 16.0),
            // Orders Section
            const Text(
              "Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildToggleButtons(),
            const SizedBox(height: 16.0),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(child: Text("Orders Chart Placeholder")),
            ),
            const SizedBox(height: 16.0),
            // Order List Section
            const Text(
              "Order List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildOrderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String percentage) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              percentage,
              style: TextStyle(fontSize: 14, color: Colors.blue),
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

  Widget _buildOrderList() {
    final orders = [
      {"name": "Albert Yoga", "date": "Jan 25th, 2020", "price": "\$8.50"},
      {"name": "Dicky Carlo", "date": "Jan 26th, 2020", "price": "\$8.50"},
      {"name": "Mario Ahmad", "date": "Jan 27th, 2020", "price": "\$8.50"},
    ];
    return Column(
      children: orders.map((order) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(order['name']!),
          subtitle: Text(order['date']!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                order['price']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "New Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
