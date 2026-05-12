import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/course_model.dart';

class CourseService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addCourse(Course course) async {
    await _firestore.collection('courses').doc(course.id).set(course.toMap());
  }

  Future<void> updateCoursePrice(String id, double newPrice) async {
    await _firestore.collection('courses').doc(id).update({'price': newPrice});
  }

  Future<void> buyCourse(String id, String userEmail) async {
    await _firestore.collection('courses').doc(id).update({
      'purchasedBy': FieldValue.arrayUnion([userEmail])
    });
  }

  Future<List<Course>> getCourses() async {
    final snapshot = await _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => Course.fromMap(doc.data())).toList();
  }
}