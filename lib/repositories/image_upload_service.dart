import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

//Upload Image to the firebase storage
  Future<String?> uploadImage(String filePath) async {
    Reference ref = _storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    File file = File(filePath);
    try {
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  //Delete image from firebase storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
