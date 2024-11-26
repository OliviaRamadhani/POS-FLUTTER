import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) onCartUpdated;

  const CartScreen({
    Key? key,
    required this.cart,
    required this.onCartUpdated,
    required void Function(int index) removeItem,
    required void Function(int index, int change) updateQuantity,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> _cart;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cart = List<Map<String, dynamic>>.from(widget.cart);
  }

  void updateQuantity(int index, int change) {
    setState(() {
      _cart[index]['quantity'] += change;
      if (_cart[index]['quantity'] <= 0) {
        _cart.removeAt(index);
      }
      // Panggil callback untuk update cart di parent
      widget.onCartUpdated(_cart);
    });
  }

  void removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
      // Panggil callback untuk update cart di parent
      widget.onCartUpdated(_cart);
    });
  }

  void clearCart() {
    setState(() {
      _cart.clear();
      // Panggil callback untuk update cart di parent
      widget.onCartUpdated(_cart);
    });
  }

  String formatCurrency(double amount) {
    return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}"; 
  }

  double calculateTotal() {
    return _cart.fold(0, (sum, item) => sum + (item['price'] * (item['quantity'] ?? 1)));
  }

  Future<void> checkout(BuildContext context) async {
    final name = _nameController.text.trim();
    final notes = _notesController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan nama Anda terlebih dahulu')),
      );
      return;
    }

    final data = {
      'name': name,
      'notes': notes,
      'items': _cart.map((item) {
        return {
          'id': item['id'],
          'name': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
        };
      }).toList(),
      'total_price': calculateTotal(),
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://192.168.2.102/api/orders/'), // Ganti dengan endpoint Laravel Anda
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your-auth-token', // Tambahkan token autentikasi jika diperlukan
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Reset cart setelah berhasil checkout
        clearCart();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil dibuat!')),
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: ${errorData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Konfirmasi Pesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nama Pemesan', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(name),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatCurrency(calculateTotal()), style: TextStyle(color: Colors.black)),
              ],
            ),
            if (notes.isNotEmpty) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(notes),
                ],
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset cart setelah checkout
                clearCart();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pesanan berhasil dibuat!'),
                    backgroundColor: Color.fromARGB(255, 5, 14, 61),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 5, 14, 61),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Konfirmasi Pesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Keranjang',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            onPressed: clearCart,
          ),
        ],
      ),
      body: _cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/shopping.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang Anda kosong',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yuk, cari makanan favoritmu!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Pesanan Anda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ...List.generate(_cart.length, (index) {
                  final item = _cart[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            item["imageUrl"] ?? 'https://via.placeholder.com/100',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  formatCurrency(item["price"]),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 5, 14, 61),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Color.fromARGB(255, 5, 14, 61),),
                                onPressed: () => updateQuantity(index, -1),
                              ),
                              Text(
                                '${item["quantity"] ?? 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: Color.fromARGB(255, 5, 14, 61),),
                                onPressed: () => updateQuantity(index, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Penerima',
                    hintText: 'Masukkan nama Anda',
                    prefixIcon: Icon(Icons.person, color: Color.fromARGB(255, 5, 14, 61),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color.fromARGB(255, 5, 14, 61), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Catatan Pesanan',
                    hintText: 'Tambahkan catatan (opsional)',
                    prefixIcon: Icon(Icons.notes, color: Color.fromARGB(255, 5, 14, 61), ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color.fromARGB(255, 5, 14, 61), width: 2),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Pesanan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        formatCurrency(calculateTotal()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 5, 14, 61),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => checkout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 5, 14, 61), 
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Pesan Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Menjadikan teks berwarna putih
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}