import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/community_model.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Community>> getCommunities() async {
    final snapshot = await _firestore
        .collection('communities')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => Community.fromMap(doc.data())).toList();
  }

  Future<void> createCommunity(Community community) async {
    await _firestore
        .collection('communities')
        .doc(community.id)
        .set(community.toMap());
  }

  Future<void> updateCommunity(Community community) async {
    await _firestore
        .collection('communities')
        .doc(community.id)
        .update(community.toMap());
  }

  Future<void> deleteCommunity(String communityId) async {
    await _firestore.collection('communities').doc(communityId).delete();
  }

  Future<void> updateCommunityMembers(String communityId, List<String> members) async {
    await _firestore
        .collection('communities')
        .doc(communityId)
        .update({'members': members});
  }

  Future<void> toggleLike(String communityId, String userEmail) async {
    final docRef = _firestore.collection('communities').doc(communityId);
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

  // Comments for communities
  Stream<List<Map<String, dynamic>>> streamComments(String communityId) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => {...d.data(), "id": d.id}).toList());
  }

  Future<void> addComment(String communityId, String author, String text) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('comments')
        .add({
      "author": author,
      "text": text,
      "time": FieldValue.serverTimestamp(),
    });
  }
}
