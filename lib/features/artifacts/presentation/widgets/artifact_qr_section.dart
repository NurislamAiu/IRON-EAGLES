import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ArtifactQrSection extends StatelessWidget {
  final TextEditingController titleController;

  const ArtifactQrSection({
    super.key,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    final text = titleController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔳 QR-код артефакта',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),

        if (text.isEmpty)
          const Text(
            'Введите название, чтобы сгенерировать QR-код',
            style: TextStyle(color: Colors.white54),
          ),

        if (text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: 'Artifact: $text',
              version: QrVersions.auto,
              size: 160,
              eyeStyle: QrEyeStyle(
                color: Colors.brown,
                eyeShape: QrEyeShape.square,
              ),
              dataModuleStyle: QrDataModuleStyle(
                color: Colors.brown.shade800,
              ),
            ),
          ),
      ],
    );
  }
}
