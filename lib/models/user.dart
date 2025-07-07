class User {
  final String id;
  final String name;
  final String? imageUrl;
  final String? email;
  final String? token;

  User({
    required this.id,
    required this.name,
    this.imageUrl,
    this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'email': email,
    'token': token,
  };
}
