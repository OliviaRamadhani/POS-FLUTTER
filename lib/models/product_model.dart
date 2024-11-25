class Product {
  final int? id;  // id bersifat opsional, bisa null
  final String uuid;
  final String name;
  final String? category;
  final String description;
  final String imageUrl;
  final int price;
  bool isSoldOut;

  Product({
    required this.uuid,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isSoldOut,
    this.id, // id bersifat opsional di konstruktor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],  // id hanya diambil saat parsing JSON
      uuid: json['uuid'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: json['price'],
      isSoldOut: json['is_sold_out'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'category': category,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'is_sold_out': isSoldOut ? 1 : 0,
      // id tidak perlu dikirim jika tidak diperlukan
    };
  }
}
