import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/product_api.dart';
import '../models/product_model.dart';
import 'package:logger/logger.dart';  // Logger for debugging

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Menu2(),
    );
  }
}

class Menu2 extends StatefulWidget {
  const Menu2({super.key});

  @override
  _Menu2State createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {
  final ProductApi _productApi = ProductApi();
  List<Product> products = [];
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String selectedCategory = 'Food';

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final Logger logger = Logger();  // For logging

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() => isLoading = true);
      products = await _productApi.fetchProducts();
      if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      logger.e('Error fetching products: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _addProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory.isEmpty) {
      logger.e('Please fill all required fields');
      return;
    }

    final newProduct = Product(
      id: 0,
      uuid: '',
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      imageUrl: imageUrlController.text,
      isSoldOut: false,
      category: selectedCategory,
    );

    try {
      final response = await _productApi.createProduct(newProduct, imageFile: imageFile);

      _fetchProducts();
    } catch (e) {
      logger.e('Error adding product: $e');
    }
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await _productApi.deleteProduct(id);
      _fetchProducts();
    } catch (e) {
      logger.e('Error deleting product: $e');
    }
  }

  Future<void> _toggleSoldOut(Product product) async {
    try {
      await _productApi.toggleSoldOut(product.id);
      _fetchProducts();
    } catch (e) {
      logger.e('Error toggling sold-out status: $e');
    }
  }

  // Handle image picker
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Product Name")),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price")),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: ['Food', 'Drink', 'Dessert'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Image picker button
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                imageFile != null
                    ? Image.file(imageFile!, width: 100, height: 100, fit: BoxFit.cover)
                    : const SizedBox(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _addProduct();  // Wait until product is added
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("Price: ${product.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(product.isSoldOut ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () async {
                          await _toggleSoldOut(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
