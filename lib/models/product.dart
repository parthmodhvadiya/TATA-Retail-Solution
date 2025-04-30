class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final double gstRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.gstRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
        quantity: (json['quantity'] is num) ? json['quantity'].toInt() : 0,
        gstRate: (json['gstRate'] is num) ? json['gstRate'].toDouble() : 0.0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'].toString())
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing Product from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'gstRate': gstRate,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
    } catch (e) {
      print('Error converting Product to JSON: $e');
      rethrow;
    }
  }

  double get finalPrice => price + (price * gstRate / 100);
}
