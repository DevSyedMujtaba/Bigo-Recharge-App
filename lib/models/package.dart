class Package {
  final String id;
  final String name;
  final int diamondAmount;
  final double price;
  final double discountAmount;
  final String? description;
  final String? image;

  Package({
    required this.id,
    required this.name,
    required this.diamondAmount,
    required this.price,
    required this.discountAmount,
    this.description,
    this.image,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      diamondAmount: json['diamondAmount'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }
} 