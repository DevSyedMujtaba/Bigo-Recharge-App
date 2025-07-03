class User {
  final String id;
  final String name;
  final String? imageUrl;
  final String? email;

  User({required this.id, required this.name, this.imageUrl, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'email': email,
  };
} 