import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // Import ImagePicker
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
  late File? imageFile;  // Menggunakan File untuk gambar
  late int price;
  final ProductApi productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      // Jika edit, isi form dengan data produk yang ada
      final product = widget.product!;
      name = product.name;
      description = product.description;
      imageFile = null; // Anda bisa menggunakan URL gambar untuk edit jika diperlukan
      price = product.price;
    } else {
      // Jika tambah, buat data kosong
      name = '';
      description = '';
      imageFile = null;
      price = 0;
    }
  }

  // Fungsi untuk memilih gambar dari galeri atau kamera
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);  // Simpan gambar yang dipilih
  //     });
  //   }
  // }

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
              // Gambar produk
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     padding: EdgeInsets.all(10),
              //     color: Colors.grey[200],
              //     child: imageFile == null
              //         ? Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Icon(Icons.add_a_photo, color: Colors.grey),
              //               Text('Tap to pick an image'),
              //             ],
              //           )
              //         : Image.file(imageFile!, height: 150), // Menampilkan gambar yang dipilih
              //   ),
              // ),
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
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final product = Product(
        id: widget.isEdit ? widget.product!.id : 0,  // Gunakan ID produk yang ada saat edit
        name: name,
        description: description,
        imageUrl: '',  // Anda bisa meng-upload gambar ke server dan dapatkan URL-nya
        price: price,
        isSoldOut: false,  // Default isSoldOut = false
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
