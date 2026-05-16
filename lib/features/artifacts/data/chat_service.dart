import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/chat_message_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> streamMessages(String expeditionId) {
    return _db
        .collection('expeditions')
        .doc(expeditionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage(ChatMessage message) async {
    await _db
        .collection('expeditions')
        .doc(message.expeditionId)
        .collection('messages')
        .add(message.toMap());
  }
}
