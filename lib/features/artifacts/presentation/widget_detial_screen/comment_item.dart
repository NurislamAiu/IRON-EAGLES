import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> c;

  const CommentItem(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final ts = c["time"];
    final date = ts is DateTime ? ts : ts?.toDate();

    final formatted = date == null
        ? "..."
        : DateFormat("dd.MM.yyyy HH:mm").format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c["author"],
                  style: TextStyle(
                      color: Colors.brown.shade200,
                      fontWeight: FontWeight.bold)),
              Text(formatted,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text(c["text"],
              style: const TextStyle(
                  color: Colors.white70, fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}
