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
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _pickedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
      widget.onImagesPicked(pickedFiles.map((file) => file.path).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text("Pick Images"),
        ),
        Wrap(
          children: _pickedImages
              .map((image) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(image, width: 100, height: 100),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
