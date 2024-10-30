import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(String filePath) async {
    print('calling uploadImage function');
    print('filepath:$filePath');
    Reference ref = _storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    print('image upload service file:#=$ref');

    File file = File(filePath);
    try {
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();
      print('image_upload_service downloadUrl:$downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error occurred while uploading to Firebase: $e');
      return null;
    }
  }
}
