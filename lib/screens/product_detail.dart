import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
        backgroundColor: Color.fromARGB(255, 5, 14, 61),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0), // Increase radius for a more noticeable curve
                child: Image.network(
                  product["imageUrl"],
                  fit: BoxFit.cover, // Use cover to fill the area completely
                  height: 300,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product["name"],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                product["description"],
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'Harga: ${formatCurrency(product["price"])}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              if (product["originalPrice"] != null)
                Text(
                  'Harga Asli: ${formatCurrency(product["originalPrice"])}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onAddToCart(product); // Call function to add to cart
                  Navigator.pop(context); // Return to the previous screen after adding
                },
                child: const Text('Tambahkan ke Keranjang'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to format currency
  String formatCurrency(double amount) {
    return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }
}
