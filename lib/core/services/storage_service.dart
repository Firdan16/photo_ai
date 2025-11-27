import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Service untuk handle Firebase Storage operations
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload original image dari Flutter ke Storage
  /// Path: users/{uid}/original/{timestamp}.jpg
  ///
  /// Returns download URL of the uploaded image
  Future<String> uploadOriginal(File image) async {
    final uid = _auth.currentUser!.uid;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final ref = _storage.ref().child('users/$uid/original/$timestamp.jpg');

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  /// Upload original image from bytes (e.g., from image picker web)
  /// Path: users/{uid}/original/{timestamp}.jpg
  Future<String> uploadOriginalBytes(
    List<int> bytes, {
    String? fileName,
  }) async {
    final uid = _auth.currentUser!.uid;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final name = fileName ?? '$timestamp.jpg';

    final ref = _storage.ref().child('users/$uid/original/$name');

    await ref.putData(
      bytes as dynamic,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await ref.getDownloadURL();
  }
}
