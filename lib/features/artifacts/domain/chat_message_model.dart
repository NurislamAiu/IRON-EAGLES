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
    return ChatMessage(
      id: map['id'] ?? '',
      expeditionId: map['expeditionId'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
