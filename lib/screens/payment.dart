import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // For currency formatting

class PaymentPage extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final String notes;
  final List<Map<String, dynamic>> cart;
  

  PaymentPage({
    required this.transactionId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.cart,
    required this.notes,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String serverKey = "SB-Mid-server-6YPojuzmmkjXS41U_OOjHr6t"; // Replace with your actual server key
  final String baseUrl = "https://api.sandbox.midtrans.com/v2";

  bool isProcessing = false;
  double pemasukan = 0.0; // Variabel pemasukan lokal
  double totalAmount = 0.0; // Variabel totalAmou

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
      "payment_type": "gopay", // Pilih metode pembayaran (misalnya gopay, credit_card, dll.)
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": widget.amount,
      },
      "customer_details": {
        "first_name": widget.customerName,
        "email": widget.customerEmail,
      },
      "item_details": buildItemDetails(),
      "gopay": {
        "enable_callback": true,
        "callback_url": "https://your.callback.url", // Ganti dengan URL callback Anda
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status_code'] == '201') {
        final deeplinkUrl = data['actions']
            .firstWhere((action) => action['name'] == 'deeplink-redirect')['url'];

        // Menambahkan pemasukan jika pembayaran berhasil
        setState(() {
          pemasukan += totalAmount; // Total amount dibayar akan ditambahkan ke pemasukan
        });

        _launchUrl(deeplinkUrl); // Luncurkan URL pembayaran
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
        await launchUrl(uri, mode: LaunchMode.externalApplication); // Open in external browser
      } else {
        await launchUrl(uri, mode: LaunchMode.inAppWebView); // Open in in-app WebView if external app is not available
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

  // Function to format currency to include periods (e.g., 75.000)
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'id_ID'); // Indonesian locale
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    // Calculate the total amount from cart
    widget.cart.forEach((item) {
      totalAmount += item['price'] * item['quantity'];
    });

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card for displaying customer name and icon
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.deepPurple, size: 40),
                  title: Text(
                    'Customer Name : ${widget.customerName}',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Order Summary'),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    // Order title with an icon
                    ListTile(
                      leading: Icon(Icons.list_alt, color: Colors.deepPurple),
                      title: Text('Pesanan yang Dipesan', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    // List of ordered items
                    Column(
                      children: widget.cart.map((item) {
                        double itemTotal = item['price'] * item['quantity']; // Calculate total per item
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.network(
                              item['imageUrl'] ?? 'https://via.placeholder.com/50', // Default image
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(item['description'] ?? 'No description'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Qty: ${item['quantity']}',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                Text(
                                  'Rp ${formatCurrency(item['price'])} / item',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  'Rp ${formatCurrency(itemTotal)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Notes Section
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.note_add, color: Colors.deepPurple),
                  title: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.notes.isEmpty ? 'No notes' : widget.notes),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Payment Summary'),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Total Payment :',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Rp ${formatCurrency(totalAmount)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
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
