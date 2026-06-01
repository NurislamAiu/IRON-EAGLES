import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> c;

  const CommentItem(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final ts = c["time"];
    final date = ts is DateTime ? ts : ts?.toDate();
    final author = c["author"] ?? "Аноним";
    final text = c["text"] ?? "";

    final formatted = date == null
        ? "..."
        : DateFormat("dd.MM.yyyy HH:mm", 'ru').format(date);

    final Color avatarColor = Colors.primaries[author.hashCode % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onLongPress: () => _showSafetyMenu(context, author),
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
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text(formatted, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showSafetyMenu(context, author),
                            child: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.3), size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSafetyMenu(BuildContext context, String author) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1a1412),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orangeAccent),
              title: const Text("Пожаловаться на контент", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Спасибо! Мы проверим этот комментарий в течение 24 часов.")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined, color: Colors.redAccent),
              title: Text("Заблокировать $author", style: const TextStyle(color: Colors.white)),
              subtitle: const Text("Вы больше не будете видеть контент от этого пользователя", style: TextStyle(color: Colors.white38, fontSize: 12)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Пользователь $author заблокирован.")),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
