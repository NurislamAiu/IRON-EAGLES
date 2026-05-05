import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/expedition_model.dart';
import '../domain/chat_message_model.dart';

class ExpeditionProvider extends ChangeNotifier {
  List<Expedition> _myExpeditions = [];
  List<ChatMessage> _allMessages = [];
  bool _isLoading = true;

  List<Expedition> get myExpeditions => _myExpeditions;
  List<ChatMessage> get allMessages => _allMessages;
  bool get isLoading => _isLoading;

  ExpeditionProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadExpeditions();
    await _loadMessages();
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

  Future<void> deleteExpedition(String id) async {
    _myExpeditions.removeWhere((e) => e.id == id);
    _allMessages.removeWhere((m) => m.expeditionId == id);
    notifyListeners();
    await _saveExpeditions();
    await _saveMessages();
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

  // --- CHAT LOGIC ---

  Future<void> sendMessage({
    required String expeditionId,
    required String text,
    required String senderEmail,
  }) async {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expeditionId: expeditionId,
      senderEmail: senderEmail,
      text: text,
      timestamp: DateTime.now(),
    );

    _allMessages.add(newMessage);
    notifyListeners();
    await _saveMessages();
  }

  List<ChatMessage> getMessagesForExpedition(String expId) {
    return _allMessages.where((m) => m.expeditionId == expId).toList();
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

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_allMessages.map((m) => m.toMap()).toList());
      await prefs.setString('expedition_messages', encoded);
    } catch (e) {
      debugPrint("Error saving messages: $e");
    }
  }

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('expedition_messages');
      if (data != null) {
        final List decoded = jsonDecode(data);
        _allMessages = decoded.map((item) => ChatMessage.fromMap(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading messages: $e");
    }
  }
}
