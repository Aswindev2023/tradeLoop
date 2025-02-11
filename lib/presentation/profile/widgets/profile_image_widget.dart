import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:trade_loop/core/constants/colors.dart';

class ProfileImage extends StatefulWidget {
  final String? initialImageUrl;
  final bool isEditable;
  final Function(String?) onImagePicked;

  const ProfileImage({
    super.key,
    this.isEditable = false,
    required this.initialImageUrl,
    required this.onImagePicked,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = pickedFile.path;
        });
        widget.onImagePicked(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          ClipOval(
            child: _pickedImage != null
                ? kIsWeb
                    ? Image.network(
                        _pickedImage!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 200),
                      )
                    : Image.file(
                        File(_pickedImage!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                : widget.initialImageUrl != null &&
                        widget.initialImageUrl!.isNotEmpty
                    ? Image.network(
                        widget.initialImageUrl!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 200),
                      )
                    : const Icon(Icons.person, size: 200),
          ),
          if (widget.isEditable)
            Positioned(
              right: 70,
              bottom: 0,
              child: ClipOval(
                child: Container(
                  color: editButtonCol,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo, color: whiteColor),
                    onPressed: widget.isEditable ? _pickImage : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
