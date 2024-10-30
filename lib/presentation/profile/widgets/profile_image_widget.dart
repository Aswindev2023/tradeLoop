import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      widget.onImagePicked(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ProfileImage widget: ${widget.initialImageUrl}');
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          ClipOval(
            child: _pickedImage != null
                ? Image.file(
                    _pickedImage!,
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 200);
                        },
                      )
                    : const Icon(Icons.person, size: 200),
          ),
          if (widget.isEditable)
            Positioned(
              right: 70,
              bottom: 0,
              child: ClipOval(
                child: Container(
                  color: const Color.fromARGB(255, 32, 81, 228),
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.white),
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
