class CartItem {
  final String id;
  final String name;
  final String? image;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      image: image,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'price': price,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'],
  );
} 