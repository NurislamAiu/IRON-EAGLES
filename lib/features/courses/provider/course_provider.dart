import 'package:flutter/material.dart';
import '../data/course_service.dart';
import '../domain/course_model.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _service = CourseService();
  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _service.getCourses();
    } catch (e) {
      debugPrint("❌ Error fetching courses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      await _service.addCourse(course);
      await fetchCourses();
    } catch (e) {
      debugPrint("❌ Error adding course: $e");
      rethrow;
    }
  }

  Future<void> updatePrice(String id, double price) async {
    try {
      await _service.updateCoursePrice(id, price);
      await fetchCourses();
    } catch (e) {
      debugPrint("❌ Error updating course price: $e");
      rethrow;
    }
  }

  Future<void> buyCourse(String id, String email) async {
    try {
      await _service.buyCourse(id, email);
      await fetchCourses();
    } catch (e) {
      debugPrint("❌ Error buying course: $e");
      rethrow;
    }
  }
}