class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int goal;
  final int currentProgress;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.goal,
    this.currentProgress = 0,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    int? currentProgress,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      goal: goal,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'goal': goal,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      goal: map['goal'] ?? 0,
      currentProgress: map['currentProgress'] ?? 0,
      isUnlocked: map['isUnlocked'] ?? false,
    );
  }
}
