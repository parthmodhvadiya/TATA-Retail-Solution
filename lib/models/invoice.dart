class Invoice {
  final String id;
  final String customerName;
  final List<InvoiceItem> items;
  final double totalAmount;
  final double gstAmount;
  final double finalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    required this.gstAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    try {
      return Invoice(
        id: json['_id']?.toString() ?? '',
        customerName: json['customerName']?.toString() ?? '',
        items: (json['items'] as List?)
                ?.map((item) => InvoiceItem.fromJson(item))
                .toList() ??
            [],
        totalAmount:
            (json['totalAmount'] is num) ? json['totalAmount'].toDouble() : 0.0,
        gstAmount:
            (json['gstAmount'] is num) ? json['gstAmount'].toDouble() : 0.0,
        finalAmount:
            (json['finalAmount'] is num) ? json['finalAmount'].toDouble() : 0.0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'].toString())
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing Invoice from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'customerName': customerName,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'gstAmount': gstAmount,
        'finalAmount': finalAmount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
    } catch (e) {
      print('Error converting Invoice to JSON: $e');
      rethrow;
    }
  }
}

class InvoiceItem {
  final String productId;
  final int quantity;
  final double price;
  final double gstRate;

  InvoiceItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.gstRate,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      productId: json['productId']?.toString() ?? '',
      quantity: (json['quantity'] is num) ? json['quantity'].toInt() : 0,
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      gstRate: (json['gstRate'] is num) ? json['gstRate'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'gstRate': gstRate,
    };
  }
}
