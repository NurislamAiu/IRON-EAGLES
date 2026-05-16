import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String expeditionId;
  final String senderEmail;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.expeditionId,
    required this.senderEmail,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'senderEmail': senderEmail,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    DateTime ts = DateTime.now();
    final rawTs = map['timestamp'];
    
    if (rawTs is Timestamp) {
      ts = rawTs.toDate();
    } else if (rawTs is String) {
      ts = DateTime.tryParse(rawTs) ?? DateTime.now();
    }

    return ChatMessage(
      id: map['id'] ?? '',
      expeditionId: map['expeditionId'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      text: map['text'] ?? '',
      timestamp: ts,
    );
  }
}
