import 'package:flutter/material.dart';
import '/services/product_api.dart';
import '/models/product_model.dart';

class AddEditProductPage extends StatefulWidget {
  final bool isEdit;
  final Product? product;

  AddEditProductPage({required this.isEdit, this.product});

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String imageUrl;
  late int price;
  late bool isSoldOut;
  final ProductApi productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      // Jika edit, isi form dengan data produk yang ada
      final product = widget.product!;
      name = product.name;
      description = product.description;
      imageUrl = product.imageUrl;
      price = product.price;
      isSoldOut = product.isSoldOut;
    } else {
      // Jika tambah, buat data kosong
      name = '';
      description = '';
      imageUrl = '';
      price = 0;
      isSoldOut = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (value) => setState(() => name = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => setState(() => description = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (value) => setState(() => imageUrl = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => price = int.parse(value)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Sold Out'),
                value: isSoldOut,
                onChanged: (value) => setState(() => isSoldOut = value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.isEdit ? 'Update Product' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.isEdit ? widget.product!.id : 0,  // Gunakan ID produk yang ada saat edit
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        isSoldOut: isSoldOut,
      );

      try {
        if (widget.isEdit) {
          await productApi.updateProduct(product);  // Update produk
        } else {
          await productApi.createProduct(product);  // Tambah produk baru
        }

        Navigator.pop(context);  // Kembali ke halaman sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.isEdit ? 'Product updated successfully' : 'Product added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit product')),
        );
      }
    }
  }
}
