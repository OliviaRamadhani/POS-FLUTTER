import 'package:flutter/material.dart';

class ProductDetailSheet extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;
  final String Function(double) formatCurrency; // Add the formatCurrency parameter

  const ProductDetailSheet({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.formatCurrency, // Receive the function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product["name"],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          Image.network(product["imageUrl"]),
          const SizedBox(height: 12),
          Text(
            product["description"],
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Text(
            formatCurrency(product["price"]), // Use the passed function here
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onAddToCart(product);
              Navigator.pop(context); // Close the bottom sheet after adding to cart
            },
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
