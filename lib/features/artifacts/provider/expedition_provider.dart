import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/expedition_model.dart';

class ExpeditionProvider extends ChangeNotifier {
  List<Expedition> _myExpeditions = [];
  bool _isLoading = true;

  List<Expedition> get myExpeditions => _myExpeditions;
  bool get isLoading => _isLoading;

  ExpeditionProvider() {
    _loadExpeditions();
  }

  Future<void> createExpedition({
    required String name,
    required String description,
    required String leaderEmail,
  }) async {
    final newExpedition = Expedition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      leaderEmail: leaderEmail,
      memberEmails: [leaderEmail],
      startDate: DateTime.now(),
    );

    _myExpeditions.add(newExpedition);
    notifyListeners();
    await _saveExpeditions();
  }

  // 🗑 Delete an Expedition
  Future<void> deleteExpedition(String id) async {
    _myExpeditions.removeWhere((e) => e.id == id);
    notifyListeners();
    await _saveExpeditions();
  }

  Future<void> inviteMember(String expeditionId, String memberEmail) async {
    final index = _myExpeditions.indexWhere((e) => e.id == expeditionId);
    if (index != -1) {
      final e = _myExpeditions[index];
      if (!e.memberEmails.contains(memberEmail)) {
        final updated = Expedition(
          id: e.id,
          name: e.name,
          description: e.description,
          leaderEmail: e.leaderEmail,
          memberEmails: [...e.memberEmails, memberEmail],
          startDate: e.startDate,
        );
        _myExpeditions[index] = updated;
        notifyListeners();
        await _saveExpeditions();
      }
    }
  }

  Future<void> _saveExpeditions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_myExpeditions.map((e) => e.toMap()).toList());
      await prefs.setString('user_expeditions', encoded);
    } catch (e) {
      debugPrint("Error saving expeditions: $e");
    }
  }

  Future<void> _loadExpeditions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('user_expeditions');
      if (data != null) {
        final List decoded = jsonDecode(data);
        _myExpeditions = decoded.map((item) => Expedition.fromMap(item)).toList();
      }
    } catch (e) {
      debugPrint("Error loading expeditions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
