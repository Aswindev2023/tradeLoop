class HomePageProductModel {
  final String productId;
  final String name;
  final String description;
  final double price;
  final String condition;
  final bool isAvailable;
  final List<String> imageUrls;
  final List<String> tags;
  final String sellerId;
  final String categoryId;

  HomePageProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.condition,
    required this.isAvailable,
    required this.imageUrls,
    required this.tags,
    required this.sellerId,
    required this.categoryId,
  });

  factory HomePageProductModel.fromFirestore(Map<String, dynamic> data) {
    double parsedPrice = 0.0;
    if (data['price'] is String) {
      parsedPrice = double.tryParse(data['price']) ?? 0.0;
    } else {
      parsedPrice = 0.0;
    }
    return HomePageProductModel(
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: parsedPrice,
      condition: data['condition'] ?? 'Unknown',
      isAvailable: data['isAvailable'] ?? true,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      sellerId: data['sellerId'] ?? '',
      categoryId: data['categoryId'] ?? '',
    );
  }
}
