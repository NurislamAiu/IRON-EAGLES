import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UgcProvider extends ChangeNotifier {
  List<String> _blockedUserEmails = [];
  List<String> get blockedUserEmails => _blockedUserEmails;

  UgcProvider() {
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    _blockedUserEmails = prefs.getStringList('blocked_users') ?? [];
    notifyListeners();
  }

  Future<void> blockUser(String email) async {
    if (email.isEmpty || _blockedUserEmails.contains(email)) return;
    
    _blockedUserEmails.add(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_users', _blockedUserEmails);
    
    // Also notify developer (send to a special collection in Firestore)
    await reportContent(
      authorEmail: email,
      reason: "User Blocked by another user",
      contentType: "USER_BLOCK",
      contentId: "block_${DateTime.now().millisecondsSinceEpoch}",
    );
    
    notifyListeners();
  }

  Future<void> unblockUser(String email) async {
    _blockedUserEmails.remove(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_users', _blockedUserEmails);
    notifyListeners();
  }

  bool isBlocked(String email) {
    return _blockedUserEmails.contains(email);
  }

  Future<void> reportContent({
    required String authorEmail,
    required String reason,
    required String contentType,
    required String contentId,
    String? contentText,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'authorEmail': authorEmail,
        'reason': reason,
        'contentType': contentType,
        'contentId': contentId,
        'contentText': contentText,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      debugPrint("Error reporting content: $e");
    }
  }
}
