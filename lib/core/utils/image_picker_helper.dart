import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Helper class for picking images
class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
