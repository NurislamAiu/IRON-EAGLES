class Expedition {
  final String id;
  final String name;
  final String description;
  final String leaderEmail;
  final List<String> memberEmails;
  final List<String> likes; // 🔥 Added likes
  final DateTime startDate;

  Expedition({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderEmail,
    required this.memberEmails,
    this.likes = const [], // 🔥 Added likes
    required this.startDate,
  });

  Expedition copyWith({
    String? id,
    String? name,
    String? description,
    String? leaderEmail,
    List<String>? memberEmails,
    List<String>? likes,
    DateTime? startDate,
  }) {
    return Expedition(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      leaderEmail: leaderEmail ?? this.leaderEmail,
      memberEmails: memberEmails ?? this.memberEmails,
      likes: likes ?? this.likes,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaderEmail': leaderEmail,
      'memberEmails': memberEmails,
      'likes': likes, // 🔥 Added likes
      'startDate': startDate.toIso8601String(),
    };
  }

  factory Expedition.fromMap(Map<String, dynamic> map) {
    return Expedition(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      leaderEmail: map['leaderEmail'] ?? '',
      memberEmails: List<String>.from(map['memberEmails'] ?? []),
      likes: List<String>.from(map['likes'] ?? []), // 🔥 Added likes
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
    );
  }
}
