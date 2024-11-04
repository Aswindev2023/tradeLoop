class ProductModel {
  final String? productId;
  final String name;
  final String description;
  final String price;
  final String condition;
  final String datePosted;
  final bool isAvailable;
  final List<String> imageUrls;
  final List<String> tags;
  final String sellerId;

  ProductModel({
    this.productId,
    required this.name,
    required this.description,
    required this.condition,
    required this.price,
    required this.datePosted,
    required this.isAvailable,
    required this.imageUrls,
    required this.tags,
    required this.sellerId,
  });
  ProductModel copyWith({
    String? productId,
    String? name,
    String? description,
    String? price,
    String? condition,
    String? datePosted,
    bool? isAvailable,
    List<String>? imageUrls,
    List<String>? tags,
    String? sellerId,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      datePosted: datePosted ?? this.datePosted,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      sellerId: sellerId ?? this.sellerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'condition': condition,
      'datePosted': datePosted,
      'isAvailable': isAvailable,
      'imageUrls': imageUrls,
      'tags': tags,
      'sellerId': sellerId,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      condition: json['condition'] as String,
      price: json['price'] as String,
      datePosted: json['datePosted'] as String,
      isAvailable: json['isAvailable'] as bool,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((url) => url as String)
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag as String)
              .toList() ??
          [],
      sellerId: json['sellerId'] as String,
    );
  }
}
