import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final List<Map<String, dynamic>> cart;

  PaymentPage({
    required this.transactionId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.cart,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String serverKey = "SB-Mid-server-6YPojuzmmkjXS41U_OOjHr6t";
  final String baseUrl = "https://api.sandbox.midtrans.com/v2";

  bool isProcessing = false;

  String generateOrderId() {
    return "order_${DateTime.now().millisecondsSinceEpoch}";
  }

  List<Map<String, dynamic>> buildItemDetails() {
    return widget.cart.map((item) {
      return {
        "id": item['id'],
        "price": item['price'],
        "quantity": item['quantity'],
        "name": item['name'],
      };
    }).toList();
  }

  Future<void> processPayment() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final url = Uri.parse('$baseUrl/charge');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$serverKey:'))}',
      };

      final orderId = generateOrderId();

      final body = jsonEncode({
        "payment_type": "gopay",
        "transaction_details": {
          "order_id": orderId,
          "gross_amount": widget.amount,
        },
        "customer_details": {
          "first_name": widget.customerName,
          "email": widget.customerEmail,
        },
        "item_details": buildItemDetails(),
      });

      final response = await http.post(url, headers: headers, body: body);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status_code'] == '201') {
          final deeplinkUrl = data['actions'][1]['url'];
          _launchUrl(deeplinkUrl);
        } else {
          _showMessage("Payment failed: ${data['status_message']}");
        }
      } else {
        _showMessage("Error: ${response.body}");
      }
    } catch (e) {
      _showMessage("Error occurred: $e");
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      _showMessage("Error launching URL: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Payment",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10, 
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Action for the button
              print("Info clicked");
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Action for the button
              print("Settings clicked");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Order Summary'),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.deepPurple),
                  title: Text('Customer name', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.customerName),
                ),
              ),
              SizedBox(height: 10),
              Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: widget.cart.map((item) {
                  return ListTile(
                    leading: Icon(Icons.confirmation_number, color: Colors.deepPurple),
                    title: Text('${item['name']} - Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['quantity'].toString()),
                  );
                }).toList(),
              ),
            ),

              SizedBox(height: 10),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.deepPurple),
                  title: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Rp ${widget.amount.toStringAsFixed(0)}'),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Payment Summary'),
             Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Total Payment :', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepPurple
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Rp ${widget.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,  // Larger font size for emphasis
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

              SizedBox(height: 20),
              SizedBox(height: 30),
              Center(
                child: isProcessing
                    ? CircularProgressIndicator(color: Colors.deepPurple)
                    : ElevatedButton.icon(
                        onPressed: processPayment,
                        icon: Icon(Icons.payment_rounded, color: Colors.white),
                        label: Text("Proceed to Payment", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 6,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
