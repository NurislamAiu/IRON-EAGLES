import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamComments(String artifactId) {
    return _db
        .collection('artifacts')
        .doc(artifactId)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => {...d.data(), "id": d.id}).toList());
  }

  Future<void> addComment(String artifactId, String author, String text) {
    return _db
        .collection('artifacts')
        .doc(artifactId)
        .collection('comments')
        .add({
      "author": author,
      "text": text,
      "time": FieldValue.serverTimestamp(),
    });
  }
}
