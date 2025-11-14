class OrderItem {
  final String soleName;
  final String soleColor;
  final double unitPrice;
  final Map<String, int> sizes;
  final int totalQuantity;
  final double subtotal;

  OrderItem({
    required this.soleName,
    required this.soleColor,
    required this.unitPrice,
    required this.sizes,
    required this.totalQuantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final Map<String, int> sizesMap = {};
    if (json['sizes'] is Map) {
      (json['sizes'] as Map).forEach((k, v) {
        sizesMap[k.toString()] = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
      });
    }

    return OrderItem(
      soleName: json['soleName']?.toString() ?? '',
      soleColor: json['soleColor']?.toString() ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      sizes: sizesMap,
      totalQuantity: (json['totalQuantity'] ?? 0),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soleName': soleName,
      'soleColor': soleColor,
      'unitPrice': unitPrice,
      'sizes': sizes,
      'totalQuantity': totalQuantity,
      'subtotal': subtotal,
    };
  }
}
