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

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
    );
  }
}
