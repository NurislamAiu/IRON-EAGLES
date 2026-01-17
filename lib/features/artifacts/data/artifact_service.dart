import 'dart:typed_data';
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/artifact_model.dart';

class ArtifactService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // =====================================================================
  // 🟢 1. ADD ARTIFACT (уже есть)
  // =====================================================================
  Future<void> addArtifact({
    required Artifact artifact,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    if (!kIsWeb && imageFile == null) {
      throw 'imageFile is required for mobile';
    }
    if (kIsWeb && imageBytes == null) {
      throw 'imageBytes is required for web';
    }

    String imageUrl = "";

    final ref = _storage
        .ref()
        .child('artifacts/${artifact.id}_${artifact.title}.jpg');

    if (imageFile != null) {
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    if (imageBytes != null) {
      await ref.putData(imageBytes);
      imageUrl = await ref.getDownloadURL();
    }

    final keywords = _generateKeywords(
      artifact.title,
      artifact.period,
      artifact.foundLocation,
      artifact.category,
    );

    final data = {
      ...artifact.toMap(),
      'imageUrl': imageUrl,
      'searchKeywords': keywords,
    };

    await _firestore.collection('artifacts').doc(artifact.id).set(data);
  }

  // =====================================================================
  // 🟡 2. UPDATE ARTIFACT (НОВАЯ ФУНКЦИЯ)
  // =====================================================================
  /// -----------------------------------------------------
  /// 🟦 UPDATE ARTIFACT
  /// -----------------------------------------------------
  Future<void> updateArtifact({
    required Artifact artifact,
    File? newImageFile,
    Uint8List? newImageBytes,
  }) async {
    String imageUrl = artifact.imageUrl;

    // Если есть новое изображение — перезаливаем
    if (newImageFile != null || newImageBytes != null) {
      final ref = _storage
          .ref()
          .child('artifacts/${artifact.id}_${artifact.title}.jpg');

      if (newImageFile != null) {
        await ref.putFile(
          newImageFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      if (newImageBytes != null) {
        await ref.putData(
          newImageBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      imageUrl = await ref.getDownloadURL();
    }

    final data = {
      ...artifact.toMap(),
      'imageUrl': imageUrl,
    };

    await _firestore
        .collection('artifacts')
        .doc(artifact.id)
        .update(data);
  }


  // =====================================================================
  // 🔍 3. GET ALL
  // =====================================================================
  Future<List<Artifact>> getAllArtifacts() async {
    final snapshot = await _firestore
        .collection('artifacts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Artifact.fromMap(doc.data())).toList();
  }

  // =====================================================================
  // 🔍 4. Search keywords
  // =====================================================================
  List<String> _generateKeywords(
      String title,
      String period,
      String location,
      String category,
      ) {
    final words =
    '$title $period $location $category'.toLowerCase().split(' ');

    final set = <String>{};

    for (final w in words) {
      if (w.trim().isEmpty) continue;

      for (int i = 1; i <= w.length; i++) {
        set.add(w.substring(0, i));
      }
    }

    return set.toList();
  }
}
