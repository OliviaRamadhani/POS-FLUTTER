class User {
  final int id;
  final String uuid;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String? photo;
  final List<String> permission;
  final Role role;

  User({
    required this.id,
    required this.uuid,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    this.photo,
    required this.permission,
    required this.role,
  });

  // fromJson sudah ada
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      permission: List<String>.from(json['permission']),
      role: Role.fromJson(json['role']),
    );
  }

  // toJson untuk mengonversi objek User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'photo': photo,
      'permission': permission,
      'role': role.toJson(),
    };
  }
}

class Role {
  final int id;
  final String name;
  final String fullName;

  Role({
    required this.id,
    required this.name,
    required this.fullName,
  });

  // fromJson sudah ada
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
    );
  }

  // toJson untuk mengonversi objek Role ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
    };
  }
}
