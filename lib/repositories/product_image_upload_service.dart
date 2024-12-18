import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ProductImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String?>> uploadImages(List<String> filePaths) async {
    List<String?> downloadUrls = [];

    for (String filePath in filePaths) {
      try {
        File file = File(filePath);

        // Check if the file exists
        if (!file.existsSync()) {
          print('File does not exist: $filePath');
          downloadUrls.add(null);
          continue;
        }

        // Extract file extension
        String extension = filePath.split('.').last;

        // Create a unique path for the file
        Reference ref = _storage.ref().child(
            'product_images/${DateTime.now().millisecondsSinceEpoch}.$extension');

        print('Uploading image from path: $filePath');
        print('Using storage path: ${ref.fullPath}');

        // Upload the file and get the download URL
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        String downloadUrl = await snapshot.ref.getDownloadURL();

        print('Uploaded image URL: $downloadUrl');

        downloadUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading $filePath: $e');
        downloadUrls.add(null);
      }
    }

    print('Final download URLs: $downloadUrls');
    return downloadUrls;
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (String url in imageUrls) {
        print('Processing URL for deletion: $url');

        // If the URL is a download URL, convert it to the gs:// format
        if (url.startsWith("https://firebasestorage.googleapis.com")) {
          String gsUrl = url
              .replaceFirst(
                "https://firebasestorage.googleapis.com/v0/b/",
                "gs://",
              )
              .split("?")[0]
              .replaceAll("%2F", "/");

          gsUrl = gsUrl.replaceFirst("/o/", "/");

          print('Converted URL to gs:// format: $gsUrl');

          final ref = FirebaseStorage.instance.refFromURL(gsUrl);
          await ref.delete();
          print('Deleted image: $gsUrl');
        } else if (url.startsWith("gs://")) {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
          print('Deleted image: $url');
        } else {
          print('Invalid URL format for deletion: $url');
        }
      }
    } catch (e) {
      print('Error deleting images: ${e.toString()}');
      rethrow;
    }
  }
}
