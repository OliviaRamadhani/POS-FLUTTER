import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '/models/product_model.dart';
import '/services/product_api.dart';
import 'dart:io'; // Import dart:io for File

class ProductEditScreen extends StatefulWidget {
  final Product product;
  final Function onUpdate;

  const ProductEditScreen({required this.product, required this.onUpdate});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? selectedCategory; // To hold the selected category
  final List<String> categories = ['makanan', 'minuman', 'dessert']; // Define categories
  File? _imageFile; // To hold the selected image file

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());
    selectedCategory = widget.product.category; // Set the initial category
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedProduct = Product(
          id: widget.product.id,
          uuid: widget.product.uuid,
          name: nameController.text,
          category: selectedCategory, // Use the selected category
          description: descriptionController.text,
          imageUrl: widget.product.imageUrl, // Keep the old image URL if no new image is selected
          price: int.parse(priceController.text),
          isSoldOut: widget.product.isSoldOut,
        );

        // Call the updateProduct method from ProductApi
        await ProductApi().updateProduct(updatedProduct, imageFile: _imageFile);
        
        // Call the onUpdate function passed from Inventory
        widget.onUpdate();
        
        // Close the edit screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path); // Set the selected image file
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product: ${widget.product.name}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Price cannot be empty' : null,
              ),
              const SizedBox(height: 20),
              // Dropdown for category selection
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 20),
              // Button to pick an image
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              // Display the selected image if available
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}