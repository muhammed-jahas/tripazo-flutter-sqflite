import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageHelper {
  static Future<String?> openCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        String? croppedImagePath = await _cropImage(pickedImage.path);
        if (croppedImagePath != null) {
          print('Image selected from camera: $croppedImagePath');
          return croppedImagePath;
        }
      }

      print('No image selected from camera');
      return null;
    } catch (e) {
      print('Error selecting image from camera: $e');
      return null;
    }
  }

  static Future<String?> openGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        String? croppedImagePath = await _cropImage(pickedImage.path);
        if (croppedImagePath != null) {
          print('Image selected from gallery: $croppedImagePath');
          return croppedImagePath;
        }
      }

      print('No image selected from gallery');
      return null;
    } catch (e) {
      print('Error selecting image from gallery: $e');
      return null;
    }
  }

  static Future<String?> _cropImage(String imagePath) async {
    try {
      final imageCropper = ImageCropper();
      final croppedImage = await imageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
        ],
        compressQuality: 70,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (croppedImage != null) {
        // Store the cropped image to a custom directory
        String customDirectoryPath = await getCustomDirectoryPath();
        String imageName = path.basename(croppedImage.path);
        String newImagePath = path.join(customDirectoryPath, imageName);
        await File(croppedImage.path).copy(newImagePath);

        return newImagePath;
      }

      return null;
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    }
  }

  static Future<String> getCustomDirectoryPath() async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final customDirectoryPath = path.join(directory.path, 'custom_directory');
    await Directory(customDirectoryPath).create(recursive: true);
    return customDirectoryPath;
  }
}
