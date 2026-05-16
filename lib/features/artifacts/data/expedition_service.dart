import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/expedition_model.dart';
import '../domain/chat_message_model.dart';

class ExpeditionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Expedition>> getExpeditions() async {
    final snapshot = await _firestore
        .collection('expeditions')
        .orderBy('startDate', descending: true)
        .get();
    return snapshot.docs.map((doc) => Expedition.fromMap(doc.data())).toList();
  }

  Future<void> createExpedition(Expedition expedition) async {
    await _firestore
        .collection('expeditions')
        .doc(expedition.id)
        .set(expedition.toMap());
  }

  Future<void> updateExpedition(Expedition expedition) async {
    await _firestore
        .collection('expeditions')
        .doc(expedition.id)
        .update(expedition.toMap());
  }

  Future<void> deleteExpedition(String id) async {
    await _firestore.collection('expeditions').doc(id).delete();
  }

  Future<void> toggleLike(String expeditionId, String userEmail) async {
    final docRef = _firestore.collection('expeditions').doc(expeditionId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    List<String> likes = List<String>.from(doc.data()?['likes'] ?? []);
    if (likes.contains(userEmail)) {
      likes.remove(userEmail);
    } else {
      likes.add(userEmail);
    }
    await docRef.update({'likes': likes});
  }

  // --- CHAT METHODS ---

  Stream<List<ChatMessage>> streamMessages(String expeditionId) {
    return _firestore
        .collection('expeditions')
        .doc(expeditionId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage(ChatMessage message) async {
    await _firestore
        .collection('expeditions')
        .doc(message.expeditionId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  // --- TYPING STATUS ---

  Future<void> setTypingStatus(String expeditionId, String email, bool isTyping) async {
    final docRef = _firestore
        .collection('expeditions')
        .doc(expeditionId)
        .collection('typing')
        .doc(email);

    if (isTyping) {
      await docRef.set({
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.delete();
    }
  }

  Stream<List<String>> streamTypingUsers(String expeditionId) {
    return _firestore
        .collection('expeditions')
        .doc(expeditionId)
        .collection('typing')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
