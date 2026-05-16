import '../domain/achievement_model.dart';

class AchievementData {
  static List<Achievement> get initialAchievements => [
    Achievement(
      id: 'scholar',
      title: 'History Scholar',
      description: 'View 5 different artifacts.',
      icon: 'menu_book',
      goal: 5,
    ),
    Achievement(
      id: 'critic',
      title: 'Art Critic',
      description: 'Leave 3 comments on artifacts.',
      icon: 'comment',
      goal: 3,
    ),
    Achievement(
      id: '3d_master',
      title: 'Technophile',
      description: 'Examine a 3D model for the first time.',
      icon: 'view_in_ar',
      goal: 1,
    ),
  ];
}
