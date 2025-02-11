class CategoryModel {
  final String? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  /// Factory constructor to create a CategoryModel instance from Firestore data.
  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] as String,
    );
  }

  /// Converts the CategoryModel instance into a Firestore-compatible Map.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }

  /// Creates a copy of the current CategoryModel with optional updated values.
  CategoryModel copyWith({
    String? id,
    String? name,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
