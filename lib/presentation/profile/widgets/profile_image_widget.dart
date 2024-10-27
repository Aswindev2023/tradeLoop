import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onPickImage;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey,
                        child: const Icon(Icons.person,
                            size: 100, color: Colors.white), // Placeholder icon
                      );
                    },
                  )
                : Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.person,
                        size: 100, color: Colors.white), // Placeholder icon
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
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  onPressed: onPickImage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
