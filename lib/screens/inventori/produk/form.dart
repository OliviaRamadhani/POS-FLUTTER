import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/services/product_api.dart';
import '/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductApi _productApi = ProductApi();
  File? _imageFile;

  String _name = '';
  String _description = '';
  String _category = '';
  int _price = 0;
  bool _isSoldOut = false;
  final String _uuid = ''; // UUID untuk produk baru

  // Pilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk menyimpan produk baru
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Membuat objek produk
      final newProduct = Product(
        uuid: _uuid, // UUID untuk produk
        name: _name,
        category: _category,
        description: _description,
        imageUrl: '', // Image URL akan digantikan di server
        price: _price,
        isSoldOut: _isSoldOut,
      );

      try {
        // Menggunakan API untuk membuat produk baru tanpa token
        await _productApi.createProduct(
          newProduct,
          imageFile: _imageFile,
        );

        if (!mounted) return; // Cek widget masih terpasang
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan!')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: const Color.fromARGB(255, 5, 14, 61),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Nama Produk
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),

                // Input Deskripsi
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value!;
                  },
                ),

                // Input Kategori
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  onSaved: (value) {
                    _category = value!;
                  },
                ),

                // Input Harga
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = int.parse(value!);
                  },
                ),

                // Input Sold Out
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sold Out'),
                    Switch(
                      value: _isSoldOut,
                      onChanged: (value) {
                        setState(() {
                          _isSoldOut = value;
                        });
                      },
                    ),
                  ],
                ),

                // Pilih Gambar
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Pilih Gambar'),
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(width: 16),
                      Image.file(
                        _imageFile!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),

                // Tombol Simpan
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    child: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 5, 14, 61),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
