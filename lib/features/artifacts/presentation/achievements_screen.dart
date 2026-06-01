import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/achievement_provider.dart';
import '../domain/achievement_model.dart';
import '../../../core/localization/app_localizations.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AchievementProvider>();
    final achievements = provider.achievements;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(S.of(context).achievements, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background matching the app's theme
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: achievements.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return _AchievementCard(achievement: achievements[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final progress = achievement.currentProgress / achievement.goal;
    final isUnlocked = achievement.isUnlocked;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isUnlocked 
                ? Colors.orange.withOpacity(0.2) 
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnlocked 
                  ? Colors.orange.withOpacity(0.5) 
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(achievement.icon),
                size: 48,
                color: isUnlocked ? Colors.orangeAccent : Colors.white38,
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslatedTitle(context, achievement.id, achievement.title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnlocked ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTranslatedDesc(context, achievement.id, achievement.description),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
              const Spacer(),
              _buildProgressBar(progress, isUnlocked),
              const SizedBox(height: 4),
              Text(
                '${achievement.currentProgress}/${achievement.goal}',
                style: TextStyle(
                  color: isUnlocked ? Colors.orangeAccent : Colors.white60,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, bool isUnlocked) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.orangeAccent : Colors.blueAccent,
            borderRadius: BorderRadius.circular(3),
            boxShadow: isUnlocked ? [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.5),
                blurRadius: 4,
              )
            ] : null,
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'menu_book': return Icons.menu_book;
      case 'comment': return Icons.comment;
      case 'view_in_ar': return Icons.view_in_ar;
      case 'sensors': return Icons.sensors;
      default: return Icons.emoji_events;
    }
  }

  String _getTranslatedTitle(BuildContext context, String id, String fallback) {
    final translated = S.of(context).get('${id}Title');
    return translated != '${id}Title' ? translated : fallback;
  }

  String _getTranslatedDesc(BuildContext context, String id, String fallback) {
    final translated = S.of(context).get('${id}Desc');
    return translated != '${id}Desc' ? translated : fallback;
  }
}
