class Order {
  final String uuid;
  final String name;
  final String description;
  final double price;
  final String category;

  Order({
    required this.uuid,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  // Factory constructor untuk parsing JSON ke model
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(), // Mengonversi ke double
      category: json['category'],
    );
  }

  // Fungsi untuk mengonversi model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    };
  }
}
