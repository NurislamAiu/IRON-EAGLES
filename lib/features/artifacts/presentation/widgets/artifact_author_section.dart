import 'package:flutter/material.dart';

class ArtifactAuthorSection extends StatelessWidget {
  final String authorEmail;

  const ArtifactAuthorSection({
    super.key,
    required this.authorEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '👤 Автор / археолог',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, color: Colors.white70),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  authorEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
