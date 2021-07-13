import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  StorageService(this.uid);
  final String uid;

  final storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path) async {
    final file = File(path);
    final filename = basename(path);
    try {
      await storage.ref().child(uid).child(filename).putFile(file);
      return filename;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> getFileUrl(String filename) {
    final ref = storage.ref().child(uid).child(filename);
    return ref.getDownloadURL();
  }
}