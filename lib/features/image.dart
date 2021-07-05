import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:freshwatch/features/data.dart';
import 'package:image_picker/image_picker.dart';

class ImageController {

  static Future<String?> getFromGallery() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    return image?.path;
  }

  static Future<String> saveLocalImage(String imagePath) async {
    final localPath = await Storage.localPath;
    final imageName = basename(imagePath);
    final localImagePath = '$localPath/$imageName';
    await File(localImagePath).writeAsBytes(await File(imagePath).readAsBytes());
    return localImagePath;
  }
}