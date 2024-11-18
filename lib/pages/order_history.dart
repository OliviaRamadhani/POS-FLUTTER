import 'package:flutter/material.dart' show AppBar, BuildContext, Icon, Icons, ListTile, ListView, Scaffold, StatelessWidget, Text, Widget;

class OrderHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: ListView.builder(
        itemCount: 10, // Placeholder for orders
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text("Order #${index + 1}"),
            subtitle: Text("Date: 2024-11-15"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Order Details Page (implement this page)
            },
          );
        },
      ),
    );
  }
}
