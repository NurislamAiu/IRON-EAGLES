import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSafetyProvider extends ChangeNotifier {
  List<String> _blockedUsers = [];

  List<String> get blockedUsers => _blockedUsers;

  UserSafetyProvider() {
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    _blockedUsers = prefs.getStringList('blocked_users') ?? [];
    notifyListeners();
  }

  Future<void> blockUser(String email) async {
    if (!_blockedUsers.contains(email)) {
      _blockedUsers.add(email);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('blocked_users', _blockedUsers);
      notifyListeners();
    }
  }

  bool isBlocked(String email) {
    return _blockedUsers.contains(email);
  }

  Future<void> unblockAll() async {
    _blockedUsers.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('blocked_users');
    notifyListeners();
  }
}
