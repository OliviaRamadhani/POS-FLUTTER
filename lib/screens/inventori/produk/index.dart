import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/product_model.dart';
import 'package:pos2_flutter/services/product_api.dart';
import 'dart:convert';
import 'dart:io';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  final String apiUrl = "http://192.168.2.139:8000/api/inventori/produk";
  List<Map<String, dynamic>> menuItems = [];
  List<String> categories = ['All'];
  String selectedCategory = 'All';

  Future<List<Map<String, dynamic>>> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        menuItems = data.map((item) {
          return {
            "id": item["id"],
            "name": item["name"],
            "description": item["description"] ?? '',
            "price": (item["price"] is int) ? (item["price"] as int).toDouble() : item["price"],
            "originalPrice": item["original_price"] != null
                ? (item["original_price"] is int ? (item["original_price"] as int).toDouble() : item["original_price"])
                : null,
            "imageUrl": item["image_url"] ?? 'https://via.placeholder.com/80',
            "isBestSeller": item["is_best_seller"] ?? false,
            "category": item["category"] ?? 'Uncategorized',
          };
        }).toList();

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

 Future<void> editProduct(Map<String, dynamic> product) async {
  final TextEditingController nameController = TextEditingController(text: product['name']);
  final TextEditingController descriptionController = TextEditingController(text: product['description']);
  final TextEditingController priceController = TextEditingController(text: product['price'].toString());
  final TextEditingController categoryController = TextEditingController(text: product['category']);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Produk"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedProduct = Product(
                id: product['id'],
                name: nameController.text,
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? product['price'],
                isSoldOut: false, // Sesuaikan jika diperlukan
                imageUrl: product['imageUrl'],
              );

              try {
                ProductApi productApi = ProductApi();
                await productApi.updateProduct(updatedProduct, token: "auth_token"); // Tambahkan token di sini
                setState(() {
                  final index = menuItems.indexWhere((item) => item['id'] == product['id']);
                  if (index != -1) {
                    menuItems[index] = {
                      "id": updatedProduct.id,
                      "name": updatedProduct.name,
                      "description": updatedProduct.description,
                      "price": updatedProduct.price,
                      "category": categoryController.text,
                      "imageUrl": updatedProduct.imageUrl,
                    };
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Produk berhasil diperbarui")),
                );
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Terjadi kesalahan: $e")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      );
    },
  );
}

  List<Map<String, dynamic>> filterItemsByCategory() {
    if (selectedCategory == 'All') {
      return menuItems;
    } else {
      return menuItems.where((item) => item['category'] == selectedCategory).toList();
    }
  }

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
                    color: selectedCategory == category ? Colors.white : Colors.black,
                  ),
                ),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = selected ? category : 'All';
                  });
                },
                selectedColor: const Color.fromARGB(255, 5, 14, 61),
                backgroundColor: Colors.grey[300],
                checkmarkColor: Colors.white,
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
        title: const Text("Inventori"),
        backgroundColor: const Color.fromARGB(255, 5, 14, 61),
      ),
      body: Column(
        children: [
          categoryFilter(),
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
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item["imageUrl"],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item["name"]),
                          subtitle: Text(item["description"]),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editProduct(item),
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
