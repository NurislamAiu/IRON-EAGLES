import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:museumcode/core/services/sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/achievement_model.dart';
import '../data/achievement_data.dart';

class AchievementProvider extends ChangeNotifier {
  List<Achievement> _achievements = AchievementData.initialAchievements;

  List<Achievement> get achievements => _achievements;

  AchievementProvider() {
    _loadAchievements();
  }

  void updateProgress(BuildContext context, String id, {int amount = 1}) {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final achievement = _achievements[index];
      
      if (achievement.isUnlocked) return;

      int newProgress = achievement.currentProgress + amount;
      bool unlocked = newProgress >= achievement.goal;

      _achievements[index] = achievement.copyWith(
        currentProgress: newProgress > achievement.goal ? achievement.goal : newProgress,
        isUnlocked: unlocked,
      );

      if (unlocked) {
        SoundService.playAchievement();
        _showUnlockToast(context, _achievements[index]);
      }

      _saveAchievements();
      notifyListeners();
    }
  }

  void _showUnlockToast(BuildContext context, Achievement achievement) {
    Flushbar(
      title: "ДОСТИЖЕНИЕ ПОЛУЧЕНО!",
      message: "${achievement.title}: ${achievement.description}",
      titleColor: Colors.orangeAccent,
      messageColor: Colors.white,
      icon: const Icon(Icons.emoji_events, color: Colors.orangeAccent, size: 28),
      backgroundColor: Colors.black.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 10,
      borderColor: Colors.orange.withOpacity(0.3),
      shouldIconPulse: true,
      mainButton: TextButton(
        onPressed: () => Flushbar(message: "View logic here").dismiss(),
        child: const Text("ОК", style: TextStyle(color: Colors.orangeAccent)),
      ),
    ).show(context);
  }

  // Helper to get achievement by ID
  Achievement? getAchievement(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _achievements.map((item) => item.toMap()).toList(),
      );
      await prefs.setString('user_achievements', encodedData);
    } catch (e) {
      debugPrint("Error saving achievements: $e");
    }
  }

  Future<void> _loadAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('user_achievements');

      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        final loadedList = decodedData
            .map((item) => Achievement.fromMap(item as Map<String, dynamic>))
            .toList();

        // Sync loaded progress with current initial structure (to handle app updates)
        for (var i = 0; i < _achievements.length; i++) {
          final loaded = loadedList.firstWhere(
            (a) => a.id == _achievements[i].id,
            orElse: () => _achievements[i],
          );
          _achievements[i] = _achievements[i].copyWith(
            currentProgress: loaded.currentProgress,
            isUnlocked: loaded.isUnlocked,
          );
        }
      }
    } catch (e) {
      debugPrint("Error loading achievements: $e");
    } finally {
      notifyListeners();
    }
  }
}
