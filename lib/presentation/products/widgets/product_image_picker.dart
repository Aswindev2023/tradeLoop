import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatefulWidget {
  final Function(List<String>) onImagesPicked;

  const ProductImagePicker({super.key, required this.onImagesPicked});

  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<File> _pickedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
      print('Picked Images: $_pickedImages');

      widget.onImagesPicked(pickedFiles.map((file) => file.path).toList());
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
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _pickedImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
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
