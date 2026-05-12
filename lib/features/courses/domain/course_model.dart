class Course {
  final String id;
  final String title;
  final String description;
  final String content;
  final String authorEmail;
  final double price; 
  final List<String> purchasedBy;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.authorEmail,
    required this.price,
    required this.purchasedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'authorEmail': authorEmail,
      'price': price,
      'purchasedBy': purchasedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      authorEmail: map['authorEmail'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      purchasedBy: List<String>.from(map['purchasedBy'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}