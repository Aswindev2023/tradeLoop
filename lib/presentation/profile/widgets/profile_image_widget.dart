import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEdit;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 70,
            bottom: 0,
            child: ClipOval(
              child: Container(
                color: const Color.fromARGB(255, 32, 81, 228),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: onEdit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
