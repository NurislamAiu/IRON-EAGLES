class Expedition {
  final String id;
  final String name;
  final String description;
  final String leaderEmail;
  final List<String> memberEmails;
  final DateTime startDate;

  Expedition({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderEmail,
    required this.memberEmails,
    required this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaderEmail': leaderEmail,
      'memberEmails': memberEmails,
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
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
    );
  }
}
