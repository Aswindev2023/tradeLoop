class CategoryModel {
  final String? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }

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
