import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pos2_flutter/screens/CartScreen.dart';
import 'package:pos2_flutter/screens/ProductDetail.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => OrderState();
}

class OrderState extends State<Order> {
  final String apiUrl = "http://192.168.2.139:8000/api/inventori/produk";
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> menuItems = [];
  List<String> categories = ['All']; // Default category list with 'All'
  String selectedCategory = 'All';

  // Function to format price to Rupiah without intl package
  String formatCurrency(double amount) {
    return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  // Fetch menu data from Laravel API and extract categories
  Future<List<Map<String, dynamic>>> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        menuItems = data.map((item) {
          return {
            "name": item["name"],
            "description": item["description"] ?? '',
            "price": (item["price"] is int) ? (item["price"] as int).toDouble() : item["price"],
            "originalPrice": item["original_price"] != null
                ? (item["original_price"] is int ? (item["original_price"] as int).toDouble() : item["original_price"])
                : null,
            "imageUrl": item["image_url"] ?? 'https://via.placeholder.com/80',
            "quantity": 1,
            "isBestSeller": item["is_best_seller"] ?? false,
            "category": item["category"] ?? 'Uncategorized',
          };
        }).toList();

        // Extract unique categories from menu items
        Set<String> uniqueCategories = {'All'};
        menuItems.forEach((item) {
          uniqueCategories.add(item['category']);
        });

        categories = uniqueCategories.toList();

        return menuItems;
      } else {
        throw Exception("Failed to load menu");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  // Add item to cart
  void addToCart(Map<String, dynamic> item) {
    setState(() {
      final existingItemIndex = cart.indexWhere((cartItem) => cartItem["name"] == item["name"]);
      if (existingItemIndex != -1) {
        cart[existingItemIndex]["quantity"] += 1;
      } else {
        cart.add({...item}); // Copy item to avoid reference issues
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item["name"]} added to cart")),
    );
  }

  // Go to Cart Page
  void goToCart() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your cart is empty!")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cart: cart,
          updateQuantity: (int index, int change) {
            setState(() {
              if (cart.isNotEmpty && index >= 0 && index < cart.length) {
                if (cart[index]["quantity"] + change > 0) {
                  cart[index]["quantity"] += change;
                } else {
                  cart.removeAt(index); // Hapus item jika kuantitas menjadi 0
                }
              }
            });
          },
          removeItem: (int index) {
            setState(() {
              if (cart.isNotEmpty && index >= 0 && index < cart.length) {
                cart.removeAt(index); // Safe removal of item
              }
            });
          },
        ),
      ),
    );
  }

  // Filter items based on category
  List<Map<String, dynamic>> filterItemsByCategory() {
    if (selectedCategory == 'All') {
      return menuItems;
    } else {
      return menuItems.where((item) => item['category'] == selectedCategory).toList();
    }
  }

  // Category Buttons / Chips
 Widget categoryFilter() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  color: selectedCategory == category
                      ? Colors.white // Warna putih jika dipilih
                      : Colors.black, // Warna default jika tidak dipilih
                ),
              ),
              selected: selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = selected ? category : 'All';
                });
              },
              selectedColor:  Color.fromARGB(255, 5, 14, 61), // Latar belakang saat dipilih
              backgroundColor: Colors.grey[300], // Latar belakang default
              checkmarkColor: Colors.white, // Warna centang
            ),
          );
        }).toList(),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Color.fromARGB(255, 5, 14, 61),
        iconTheme: const IconThemeData(color: Colors.white), // Ubah warna ikon menjadi putih
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCart,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter UI
          categoryFilter(),

          // Fetch and display products based on selected category
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchMenu(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No menu items available.'));
              } else {
                final filteredItems = filterItemsByCategory();
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: item,
                                onAddToCart: addToCart,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item["imageUrl"],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (item["isBestSeller"])
                                        Text(
                                          'Terlaris',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Text(
                                        item["name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item["description"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Display only one price
                                      Text(
                                        formatCurrency(item["price"]),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () => addToCart(item),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
