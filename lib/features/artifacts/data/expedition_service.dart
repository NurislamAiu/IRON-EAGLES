import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/expedition_model.dart';

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
}
