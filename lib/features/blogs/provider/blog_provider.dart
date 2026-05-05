import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/blog_post_model.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogPost> _blogs = [];
  bool _isLoading = true;

  List<BlogPost> get blogs => _blogs;
  bool get isLoading => _isLoading;

  BlogProvider() {
    _loadBlogs();
  }

  Future<void> addBlogPost({
    required String title,
    required String content,
    required String authorEmail,
    String imageUrl = '',
  }) async {
    final newPost = BlogPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      authorEmail: authorEmail,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      likes: [],
      comments: [],
    );

    _blogs.insert(0, newPost);
    notifyListeners();
    await _saveBlogs();
  }

  void toggleLike(String blogId, String userEmail) {
    final index = _blogs.indexWhere((b) => b.id == blogId);
    if (index != -1) {
      final blog = _blogs[index];
      final likes = List<String>.from(blog.likes);
      if (likes.contains(userEmail)) {
        likes.remove(userEmail);
      } else {
        likes.add(userEmail);
      }
      _blogs[index] = blog.copyWith(likes: likes);
      notifyListeners();
      _saveBlogs();
    }
  }

  void editComment(String blogId, String commentId, String newContent) {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      final comments = List<BlogComment>.from(blog.comments);

      final commentIndex = comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        comments[commentIndex] = comments[commentIndex].copyWith(content: newContent);

        _blogs[blogIndex] = blog.copyWith(comments: comments);
        notifyListeners();
        _saveBlogs();
      }
    }
  }

  void addComment(String blogId, String content, String authorEmail) {
    final index = _blogs.indexWhere((b) => b.id == blogId);
    if (index != -1) {
      final blog = _blogs[index];
      final newComment = BlogComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorEmail: authorEmail,
        content: content,
        createdAt: DateTime.now(),
      );
      final comments = List<BlogComment>.from(blog.comments)..add(newComment);
      _blogs[index] = blog.copyWith(comments: comments);
      notifyListeners();
      _saveBlogs();
    }
  }

  void deleteComment(String blogId, String commentId) {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      final comments = List<BlogComment>.from(blog.comments);
      comments.removeWhere((c) => c.id == commentId);
      _blogs[blogIndex] = blog.copyWith(comments: comments);
      notifyListeners();
      _saveBlogs();
    }
  }

  void addReply(String blogId, String commentId, String content, String authorEmail) {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      final comments = List<BlogComment>.from(blog.comments);
      final commentIndex = comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final newReply = BlogComment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorEmail: authorEmail,
          content: content,
          createdAt: DateTime.now(),
        );
        final replies = List<BlogComment>.from(comments[commentIndex].replies)..add(newReply);
        comments[commentIndex] = comments[commentIndex].copyWith(replies: replies);
        _blogs[blogIndex] = blog.copyWith(comments: comments);
        notifyListeners();
        _saveBlogs();
      }
    }
  }

  void editReply(String blogId, String commentId, String replyId, String newContent) {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      final comments = List<BlogComment>.from(blog.comments);
      final commentIndex = comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final replies = List<BlogComment>.from(comments[commentIndex].replies);
        final replyIndex = replies.indexWhere((r) => r.id == replyId);
        if (replyIndex != -1) {
          replies[replyIndex] = replies[replyIndex].copyWith(content: newContent);
          comments[commentIndex] = comments[commentIndex].copyWith(replies: replies);
          _blogs[blogIndex] = blog.copyWith(comments: comments);
          notifyListeners();
          _saveBlogs();
        }
      }
    }
  }

  void deleteReply(String blogId, String commentId, String replyId) {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      final comments = List<BlogComment>.from(blog.comments);
      final commentIndex = comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final replies = List<BlogComment>.from(comments[commentIndex].replies);
        replies.removeWhere((r) => r.id == replyId);
        comments[commentIndex] = comments[commentIndex].copyWith(replies: replies);
        _blogs[blogIndex] = blog.copyWith(comments: comments);
        notifyListeners();
        _saveBlogs();
      }
    }
  }

  Future<void> _saveBlogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_blogs.map((b) => b.toMap()).toList());
      await prefs.setString('user_blogs', encoded);
    } catch (e) {
      debugPrint("Error saving blogs: $e");
    }
  }

  Future<void> _loadBlogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('user_blogs');
      if (data != null) {
        final List decoded = jsonDecode(data);
        _blogs = decoded.map((item) => BlogPost.fromMap(item)).toList();
      } else {
        // Add some mock data for first run
        _blogs = [
          BlogPost(
            id: '1',
            title: 'Welcome to our Museum Blog!',
            content: 'Here archaeologists will share their latest discoveries and field notes.',
            authorEmail: 'admin@gmail.com',
            imageUrl: '',
            createdAt: DateTime.now(),
          ),
        ];
      }
    } catch (e) {
      debugPrint("Error loading blogs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
