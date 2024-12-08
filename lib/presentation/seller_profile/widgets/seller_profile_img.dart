import 'package:flutter/material.dart';

class SellerProfileImg extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String placeholderUrl;

  const SellerProfileImg({
    super.key,
    this.imageUrl,
    required this.size,
    this.placeholderUrl =
        'https://robohash.org/placeholder?set=set4&size=200x200',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        imageUrl ?? placeholderUrl,
        fit: BoxFit.cover,
        height: size,
        width: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: size,
            width: size,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: size,
          width: size,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
      ),
    );
  }
}
