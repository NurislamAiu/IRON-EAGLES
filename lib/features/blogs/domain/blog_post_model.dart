class BlogComment {
  final String id;
  final String authorEmail;
  final String content;
  final DateTime createdAt;
  final List<BlogComment> replies;

  BlogComment({
    required this.id,
    required this.authorEmail,
    required this.content,
    required this.createdAt,
    this.replies = const [],
  });

  BlogComment copyWith({
    String? id,
    String? authorEmail,
    String? content,
    DateTime? createdAt,
    List<BlogComment>? replies,
  }) {
    return BlogComment(
      id: id ?? this.id,
      authorEmail: authorEmail ?? this.authorEmail,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorEmail': authorEmail,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((r) => r.toMap()).toList(),
    };
  }

  factory BlogComment.fromMap(Map<String, dynamic> map) {
    return BlogComment(
      id: map['id'] ?? '',
      authorEmail: map['authorEmail'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      replies: (map['replies'] as List<dynamic>?)
              ?.map((r) => BlogComment.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String authorEmail;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> likes;
  final List<BlogComment> comments;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorEmail,
    required this.imageUrl,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
  });

  BlogPost copyWith({
    String? id,
    String? title,
    String? content,
    String? authorEmail,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? likes,
    List<BlogComment>? comments,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorEmail: authorEmail ?? this.authorEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorEmail': authorEmail,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      authorEmail: map['authorEmail'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      comments: (map['comments'] as List<dynamic>?)
              ?.map((c) => BlogComment.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
