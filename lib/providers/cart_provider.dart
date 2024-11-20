import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  void addToCart(Product product) {
    final existingItem = _cartItems.firstWhere(
        (item) => item['id'] == product.id, orElse: () => {});
    if (existingItem.isNotEmpty) {
      existingItem['quantity']++;
    } else {
      _cartItems.add({
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': 1,
      });
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item['id'] == product.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
