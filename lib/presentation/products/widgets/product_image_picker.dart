import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ProductImagePicker extends StatefulWidget {
  final Function(List<String>) onImagesPicked;
  final List<String> initialImages;

  const ProductImagePicker({
    super.key,
    required this.onImagesPicked,
    this.initialImages = const [],
  });

  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<String> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialImages.isNotEmpty) {
      _pickedImages = List.from(widget.initialImages);
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _pickedImages = pickedFiles.map((file) => file.path).toList();
        });
        widget.onImagesPicked(_pickedImages);
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _pickedImages.isNotEmpty
            ? PageView.builder(
                itemCount: _pickedImages.length,
                itemBuilder: (context, index) {
                  final image = _pickedImages[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb || image.startsWith('http')
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          )
                        : Image.file(
                            File(image),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  );
                },
              )
            : const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: 50,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap to pick images",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
