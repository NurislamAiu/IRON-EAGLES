import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/artifact_model.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Artifact> _favorites = [];
  bool _isLoading = true;

  List<Artifact> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    _loadFavorites();
  }

  // Check if an artifact is already in the list
  bool isFavorite(Artifact artifact) {
    return _favorites.any((item) => item.id == artifact.id);
  }

  // The "Toggle" function: if it's there, remove it. If not, add it.
  Future<void> toggleFavorite(Artifact artifact) async {
    if (isFavorite(artifact)) {
      _favorites.removeWhere((item) => item.id == artifact.id);
    } else {
      _favorites.add(artifact);
    }
    notifyListeners();
    await _saveFavorites();
  }

  // Save favorites to the phone's memory
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _favorites.map((item) => item.toMap()).toList(),
      );
      await prefs.setString('favorite_artifacts', encodedData);
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }

  // Load favorites from the phone's memory
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('favorite_artifacts');

      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        _favorites = decodedData
            .map((item) => Artifact.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
