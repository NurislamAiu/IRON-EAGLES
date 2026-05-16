import 'package:flutter/material.dart';
import '../../data/comment_service.dart';
import 'comment_item.dart';

class CommentsSection extends StatelessWidget {
  final String artifactId;
  final CommentService commentService;
  final ScrollController? controller;

  const CommentsSection({
    super.key,
    required this.artifactId,
    required this.commentService,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: commentService.streamComments(artifactId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            ),
          );
        }

        final comments = snapshot.data ?? [];

        if (comments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Text(
                    "Будьте первым, кто оставит отзыв!",
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140), // Оставляем место под клавиатуру/инпут
          itemCount: comments.length,
          itemBuilder: (context, index) => CommentItem(comments[index]),
        );
      },
    );
  }
}
