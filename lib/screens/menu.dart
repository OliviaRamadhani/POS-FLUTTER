    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert';
    import 'package:pos2_flutter/screens/CartScreen.dart';
    import 'package:pos2_flutter/screens/ProductDetailSheet.dart';

    class Order extends StatefulWidget {
      @override
      _OrderState createState() => _OrderState();
    }

    class _OrderState extends State<Order> {
      final String apiUrl = "http://192.168.2.102:8000/api/inventori/produk";
      List<Map<String, dynamic>> cart = [];
      List<Map<String, dynamic>> menuItems = [];
      List<String> categories = ['All'];
      String selectedCategory = 'All';
      bool showFloatingCart = false;

      String formatCurrency(double amount) {
        return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
      }

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

      void addToCart(Map<String, dynamic> item) {
        setState(() {
          final existingItemIndex = cart.indexWhere((cartItem) => cartItem["name"] == item["name"]);
          if (existingItemIndex != -1) {
            cart[existingItemIndex]["quantity"] += 1;
          } else {
            cart.add({...item});
          }
          showFloatingCart = true;
        });

      
      }

      void updateQuantity(int index, int change) {
        setState(() {
          cart[index]["quantity"] += change;
          if (cart[index]["quantity"] <= 0) {
            cart.removeAt(index);
          }
        });
      }

      void removeItem(int index) {
        setState(() {
          cart.removeAt(index);
        });
      }

      List<Map<String, dynamic>> filterItemsByCategory() {
        if (selectedCategory == 'All') {
          return menuItems;
        } else {
          return menuItems.where((item) => item['category'] == selectedCategory).toList();
        }
      }

      Widget categoryFilter() {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'All';
                        });
                      },
                      selectedColor: Color.fromARGB(255, 5, 14, 61),
                      backgroundColor: Colors.grey[100],
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }

      Widget buildProductCard(Map<String, dynamic> item) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              builder: (context) => ProductDetailSheet(
                product: item,
                onAddToCart: addToCart,
                formatCurrency: formatCurrency,
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
                    icon: const Icon(Icons.add_circle, color: Color.fromARGB(255, 5, 14, 61)),
                    onPressed: () => addToCart(item),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      void navigateToCart() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartScreen(
              cart: cart,
              updateQuantity: updateQuantity,
              removeItem: removeItem,
              onCartUpdated: (updatedCart) {
                setState(() {
                  cart = updatedCart;
                });
              },
            ),
          ),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
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
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            expandedHeight: 70,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: categoryFilter(),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(top: 8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => buildProductCard(filteredItems[index]),
                                childCount: filteredItems.length,
                              ),
                            ),
                          ),
                          if (cart.isNotEmpty)
                            SliverToBoxAdapter(
                              child: SizedBox(height: 80),
                            ),
                        ],
                      );
                    }
                  },
                ),
                if (cart.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: navigateToCart,
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 5, 14, 61),
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${cart.length} items",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "View Cart",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    }