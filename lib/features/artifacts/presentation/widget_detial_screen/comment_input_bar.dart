import 'package:flutter/material.dart';

class CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  /// 🔥 добавлено
  final bool enabled;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  enabled: enabled, // ← блокируем ввод
                  controller: controller,
                  maxLines: 3,
                  minLines: 1,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: enabled
                        ? "Написать комментарий..."
                        : "Войдите, чтобы писать",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // --------------------------
            //  SEND BUTTON
            // --------------------------
            GestureDetector(
              onTap: enabled ? onSend : null, // ← выключаем кнопку
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: enabled
                      ? const Color(0xFF8D6E63)
                      : Colors.grey.withOpacity(0.4), // ← серый для гостей
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.send,
                  color: enabled ? Colors.white : Colors.white30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
