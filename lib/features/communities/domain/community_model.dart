class Community {
  final String id;
  final String name;
  final String description;
  final String creatorEmail;
  final String imageUrl;
  final List<String> members;
  final List<String> likes; // 🔥 Added likes
  final DateTime createdAt;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorEmail,
    required this.imageUrl,
    required this.members,
    this.likes = const [], // 🔥 Added likes
    required this.createdAt,
  });

  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorEmail,
    String? imageUrl,
    List<String>? members,
    List<String>? likes, // 🔥 Added likes
    DateTime? createdAt,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      members: members ?? this.members,
      likes: likes ?? this.likes, // 🔥 Added likes
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorEmail': creatorEmail,
      'imageUrl': imageUrl,
      'members': members,
      'likes': likes, // 🔥 Added likes
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      creatorEmail: map['creatorEmail'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      likes: List<String>.from(map['likes'] ?? []), // 🔥 Added likes
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
