import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  bool isvideo = false;

  File? _selectedVideo;
  VideoPlayerController? videoPlayerController;

  File? get selectedVideo => _selectedVideo;

  void updateSelectedImage(File video) {
    _selectedVideo = video;
    notifyListeners();
  }

  Future<void> pickVideoFromCamera() async {
    final imgXFile = await _picker.pickVideo(source: ImageSource.camera);
    if (imgXFile != null) {
      _selectedVideo = File(imgXFile.path);
      videoPlayerController = VideoPlayerController.file(_selectedVideo!)
        ..initialize().then((_) {
          videoPlayerController!.play();
        });
      videoPlayerController!.setLooping(true);

      isvideo = true;
    }

    notifyListeners();
  }

  Future<void> pickVideoFromGallery() async {
    final imgXFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (imgXFile != null) {
      _selectedVideo = File(imgXFile.path);
      videoPlayerController = VideoPlayerController.file(_selectedVideo!)
        ..initialize().then((_) {
          videoPlayerController!.play();
        });

      videoPlayerController!.setLooping(true);
      isvideo = true;
    }

    notifyListeners();
  }

  void reset() {
    _selectedVideo = null;
    notifyListeners();
  }
}
