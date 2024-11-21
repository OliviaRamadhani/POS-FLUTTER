class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final bool isSoldOut;  // Menambahkan status sold out

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isSoldOut,  // Inisialisasi status sold out
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: json['price'],
      isSoldOut: json['is_sold_out'] ?? false,  // Menambahkan is_sold_out
    );
  }

  get category => null;
}
