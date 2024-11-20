import 'package:flutter/material.dart';
import '/services/product_api.dart';
import '/models/product_model.dart';
import 'form.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<Product>> futureProducts;
  final ProductApi productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    futureProducts = productApi.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      futureProducts = productApi.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigasi ke halaman tambah produk
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditProductPage(isEdit: false),
                ),
              ).then((_) => _refreshProducts());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            final products = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('${product.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product.id),
                    ),
                    onTap: () {
                      // Navigasi ke halaman edit produk
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProductPage(
                            isEdit: true,
                            product: product,
                          ),
                        ),
                      ).then((_) => _refreshProducts());
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await productApi.deleteProduct(id);
      _refreshProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product')),
      );
    }
  }
}
