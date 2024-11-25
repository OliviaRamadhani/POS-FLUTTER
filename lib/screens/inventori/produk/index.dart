import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pos2_flutter/screens/inventori/produk/product_edit.dart';
import 'package:pos2_flutter/models/product_model.dart'; // Import your Product model
import 'package:pos2_flutter/services/product_api.dart'; // Import your ProductApi class

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final String apiUrl = "http://192.168.2.139:8000/api/inventori/produk";
  List<Product> menuItems = [];
  List<String> categories = ['All']; // Default category list with 'All'
  String selectedCategory = 'All';

  // Fetch menu data from Laravel API and extract categories
  Future<List<Product>> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        menuItems = data.map((item) => Product.fromJson(item)).toList();

        // Extract unique categories from menu items
        Set<String> uniqueCategories = {'All'};
        menuItems.forEach((item) {
          uniqueCategories.add(item.category ?? 'Uncategorized');
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

  // Filter items based on category
  List<Product> filterItemsByCategory() {
    if (selectedCategory == 'All') {
      return menuItems;
    } else {
      return menuItems.where((item) => item.category == selectedCategory).toList();
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
                selectedColor: Color.fromARGB(255, 5, 14, 61), // Latar belakang saat dipilih
                backgroundColor: Colors.grey[300], // Latar belakang default
                checkmarkColor: Colors.white, // Warna centang
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Navigate to ProductEditScreen for editing
  void navigateToEditProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditScreen(
          product: product,
          onUpdate: () {
            // Refresh the inventory after updating
            fetchMenu();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 5, 14, 61),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Category filter UI
          categoryFilter(),

          // Fetch and display products based on selected category
          FutureBuilder<List<Product>>(
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
                        onTap: () => navigateToEditProduct(item),
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
                                    item.imageUrl,
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
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[600 ],
                                      ),
                                    ),
                                    ],
                                  ),
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