import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/artifact_service.dart';
import '../domain/artifact_model.dart';

class ArtifactProvider extends ChangeNotifier {
  final ArtifactService _service = ArtifactService();
  final AuthProviders authProvider;

  ArtifactProvider(this.authProvider);

  List<Artifact> _artifacts = [];
  bool _loading = false;

  List<Artifact> get artifacts => _artifacts;
  bool get isLoading => _loading;

  Future<void> fetchArtifacts() async {
    try {
      _loading = true;
      notifyListeners();
      _artifacts = await _service.getAllArtifacts();
    } catch (e) {
      debugPrint("❌ Error fetching artifacts: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<Artifact> myArtifacts(String email) {
    return _artifacts.where((a) => a.addedBy == email).toList();
  }

  Future<void> addArtifact({
    required Artifact artifact,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      await _service.addArtifact(
        artifact: artifact,
        imageFile: imageFile,
        imageBytes: imageBytes,
      );
      await fetchArtifacts();
    } catch (e) {
      debugPrint("❌ Error adding artifact: $e");
      rethrow;
    }
  }

  Future<void> updateArtifact({
    required Artifact artifact,
    File? newImageFile,
    Uint8List? newImageBytes,
  }) async {
    try {
      await _service.updateArtifact(
        artifact: artifact,
        newImageFile: newImageFile,
        newImageBytes: newImageBytes,
      );
      await fetchArtifacts();
    } catch (e) {
      debugPrint("❌ Error updating artifact: $e");
      rethrow;
    }
  }

  // =============================
  // 🟩 УДАЛЕНИЕ АРТЕФАКТА (ВОССТАНОВЛЕНО)
  // =============================
  Future<void> deleteArtifact(String id) async {
    try {
      await _service.deleteArtifact(id);
      _artifacts.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error deleting artifact: $e");
      rethrow;
    }
  }
}
