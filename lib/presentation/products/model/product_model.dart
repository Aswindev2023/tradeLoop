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
  final double latitude;
  final double longitude;

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
    required this.latitude,
    required this.longitude,
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
    double? latitude,
    double? longitude,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
      'tags': tags,
      'sellerId': sellerId,
      'latitude': latitude,
      'longitude': longitude,
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
      imageUrls: json['imageUrls'] as List<String>,
      tags: json['tags'] as List<String>,
      sellerId: json['sellerId'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
