import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String?>> uploadImages(List<String> filePaths) async {
    List<String?> downloadUrls = [];
    for (String filePath in filePaths) {
      Reference ref = _storage
          .ref()
          .child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      File file = File(filePath);
      try {
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading $filePath: $e');
        downloadUrls.add(null);
      }
    }
    return downloadUrls;
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    for (String imageUrl in imageUrls) {
      try {
        print('Deleting old image: $imageUrl');
        Reference ref = _storage.refFromURL(imageUrl);
        await ref.delete();
        print('Image deleted successfully.');
      } catch (e) {
        print('Error deleting image $imageUrl: $e');
      }
    }
  }
}
