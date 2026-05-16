import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Поиск археологов по email
  Future<List<Map<String, dynamic>>> searchArchaeologists(String query) async {
    if (query.isEmpty) return [];
    
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'archaeologist')
        .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('email', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
