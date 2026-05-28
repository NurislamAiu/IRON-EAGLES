import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../auth/provider/ugc_provider.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> c;

  const CommentItem(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final ugcProvider = context.watch<UgcProvider>();
    final author = c["author"] ?? "Аноним";
    final currentUserEmail = context.read<AuthProviders>().user?.email ?? '';

    // If the author is blocked, we don't show the comment
    if (ugcProvider.isBlocked(author)) {
      return const SizedBox.shrink();
    }

    final ts = c["time"];
    final date = ts is DateTime ? ts : ts?.toDate();
    final author = c["author"] ?? "Аноним";
    final text = c["text"] ?? "";

    final formatted = date == null
        ? "..."
        : DateFormat("dd.MM.yyyy HH:mm", 'ru').format(date);

    // Цвет аватара на основе имени
    final Color avatarColor = Colors.primaries[author.hashCode % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor.withOpacity(0.2),
            child: Text(
              author.isNotEmpty ? author[0].toUpperCase() : "?",
              style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (author != currentUserEmail && author != 'Аноним')
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white38, size: 18),
                        onSelected: (val) => _handleAction(context, val, author),
                        itemBuilder: (ctx) => [
                          PopupMenuItem(value: 'report', child: Text(S.of(context).report)),
                          PopupMenuItem(value: 'block', child: Text(S.of(context).blockUser)),
                        ],
                      ),
                    Text(
                      formatted,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.03)),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, String action, String email) {
    final ugc = context.read<UgcProvider>();
    if (action == 'block') {
      ugc.blockUser(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).userBlocked)),
      );
    } else if (action == 'report') {
      ugc.reportContent(
        authorEmail: email,
        reason: "User Report",
        contentType: "COMMENT",
        contentId: "comment_${c['time']}",
        contentText: c['text'],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).contentReported)),
      );
    }
  }
}
