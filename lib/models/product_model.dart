class Product {
  final int id;
  final String uuid;
  final String name;
  final String category;
  final double price;
  final String? description;
  final String? imageUrl;
  bool isSoldOut;

  Product({
    required this.id,
    required this.uuid,
    required this.name,
    required this.category,
    required this.price,
    this.description,
    this.imageUrl,
    required this.isSoldOut,
  });

  // Convert JSON to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['image_url'],
      isSoldOut: json['is_sold_out'] == 0,
    );
  }

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'is_sold_out': isSoldOut,
    };
  }
}
