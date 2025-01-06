import 'package:latlong2/latlong.dart';

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
  final String categoryId;
  final String categoryName;
  final LatLng? location;
  final String locationName;
  final bool isBanned;

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
    required this.categoryId,
    required this.categoryName,
    required this.location,
    required this.locationName,
    this.isBanned = false,
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
    String? categoryId,
    String? categoryName,
    LatLng? location,
    String? locationName,
    bool? isBanned,
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
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      location: location ?? this.location,
      locationName: locationName ?? this.locationName,
      isBanned: isBanned ?? this.isBanned,
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
      'categoryId': categoryId,
      'categoryName': categoryName,
      'locationName': locationName,
      'isBanned': isBanned,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
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
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      locationName: json['locationName'] as String,
      location: json['location'] != null
          ? LatLng(
              (json['location']['latitude'] as num).toDouble(),
              (json['location']['longitude'] as num).toDouble(),
            )
          : null,
      isBanned: json['isBanned'] as bool? ?? false,
    );
  }
}
