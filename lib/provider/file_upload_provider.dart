import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadProvider extends ChangeNotifier {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<List<String>> uploadMultipleFiles(
      {required List<File> files, required String folder}) async {
    List<String> fileUrls = [];

    for (File file in files) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      fileUrls.add(imageUrl);
    }

    return fileUrls;
  }

  Future<String?> fileUpload(
      {required File file,
      required String fileName,
      required String folder}) async {
    try {
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> updateFile({
    required File file,
    required String? oldImageUrl, // Made oldImageUrl nullable
    required String folder,
    required String name,
  }) async {
    try {
      // Extract the file name from the provided name
      String fileName = name;

      // Check if an old image URL exists before attempting to delete
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          // Delete the old file
          final oldFileRef = _storageRef.child('$folder/$fileName');
          await oldFileRef.delete();
        } catch (e) {
          print('Error deleting old image: $e');
          // Continue with the upload even if deletion fails
        }
      }

      // Upload the new file
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final newImageUrl = await snapshot.ref.getDownloadURL();
      return newImageUrl;
    } catch (e) {
      print('Error updating file: $e');
    }
    return null;
  }
}
