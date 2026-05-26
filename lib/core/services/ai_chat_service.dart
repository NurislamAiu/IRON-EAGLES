import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AiChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Путь: ai_chats / {userEmail} / messages / {msgId}
  
  Future<List<Map<String, String>>> loadChatHistory(String userEmail) async {
    try {
      final snap = await _db
          .collection('ai_chats')
          .doc(userEmail)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'role': data['role']?.toString() ?? '',
          'text': data['text']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading AI chat: $e');
      return [];
    }
  }

  Future<void> saveMessage(String userEmail, String role, String text) async {
    try {
      await _db
          .collection('ai_chats')
          .doc(userEmail)
          .collection('messages')
          .add({
        'role': role,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving AI message: $e');
    }
  }

  Future<void> clearHistory(String userEmail) async {
    try {
      final batch = _db.batch();
      final collection = _db.collection('ai_chats').doc(userEmail).collection('messages');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing AI chat: $e');
    }
  }
}
