import 'package:flutter/material.dart';

class ImageSliderWidget extends StatelessWidget {
  final List<String> imageUrls;

  const ImageSliderWidget({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth, // Full width of the screen
      height: screenHeight * 0.5, // Half of the screen's height
      child: PageView.builder(
        itemCount: imageUrls.length, // Number of images
        itemBuilder: (context, index) {
          return Image.network(
            imageUrls[index], // URL of the current image
            width: screenWidth, // Full screen width
            height: screenHeight * 0.5, // Half screen height
            fit: BoxFit.cover, // Ensure the image covers the widget
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // Image loaded

              // Show a circular progress indicator while the image is loading
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Display a placeholder if the image fails to load
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
