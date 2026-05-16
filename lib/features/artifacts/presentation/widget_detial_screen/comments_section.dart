import 'package:flutter/material.dart';
import '../../data/comment_service.dart';
import 'comment_item.dart';
import 'glass_card.dart';

import 'package:ArcheoAI/core/localization/app_localizations.dart';

class CommentsSection extends StatelessWidget {
  final String artifactId;
  final CommentService commentService;
  final EdgeInsetsGeometry? padding; // <-- ДОБАВЛЕНО

  const CommentsSection({
    super.key,
    required this.artifactId,
    required this.commentService,
    this.padding, // <-- ДОБАВЛЕНО
  });

  @override
  Widget build(BuildContext context) {
    return Padding( // <-- ДОБАВЛЕНО
      padding: padding ?? EdgeInsets.zero, // <-- ДОБАВЛЕНО
      child: StreamBuilder(
        stream: commentService.streamComments(artifactId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return GlassCard(
              child: Text(S.of(context).loadingComments,
                  style: const TextStyle(color: Colors.white54)),
            );
          }

          final comments = snapshot.data!;
          final hasMore = comments.length > 3;
          final visible = hasMore ? comments.take(3).toList() : comments;

          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(S.of(context).comments,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (hasMore)
                      GestureDetector(
                        onTap: () => _openAll(context, comments),
                        child: const Icon(Icons.expand_circle_down_rounded,
                            color: Colors.white70, size: 28),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                visible.isEmpty
                    ? Text(S.of(context).noCommentsYet,
                    style: const TextStyle(color: Colors.white54))
                    : Column(children: visible.map((c) => CommentItem(c)).toList())
              ],
            ),
          );
        },
      ),
    );
  }

  void _openAll(BuildContext context, List<Map<String, dynamic>> comments) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) {
          return Container(
            color: Colors.black.withOpacity(0.65),
            child: ListView.builder(
              controller: controller,
              itemCount: comments.length,
              itemBuilder: (_, i) => CommentItem(comments[i]),
            ),
          );
        },
      ),
    );
  }
}
