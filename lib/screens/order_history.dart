import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Import the intl package

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: 10, // Placeholder for orders
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.restaurant_menu,
                color: const Color.fromARGB(255, 19, 38, 70),
                size: 30,
              ),
              title: Text("Order #${index + 1}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: 2024-11-15"),
                  Text(
                      "Time: ${_formatTime(DateTime.now())}"), // Display current time
                  Text("Status: Delivered",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              onTap: () {
                // Show order details in a modal bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _buildOrderDetails(index + 1),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderDetails(int orderNumber) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order #$orderNumber",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Date: 2024-11-15"),
          Text("Time: ${_formatTime(DateTime.now())}"), // Display current time
          Text("Status: Delivered"),
          Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Item 1"),
            subtitle: Text("Quantity: 2"),
            trailing: Text("\$10.00"),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Item 2"),
            subtitle: Text("Quantity: 1"),
            trailing: Text("\$5.00"),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("\$25.00", style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
        ],
      ),
    );
  }

  // Function to format the current time
  String _formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
