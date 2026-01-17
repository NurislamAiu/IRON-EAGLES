import 'package:flutter/material.dart';

class ArtifactLocationSection extends StatelessWidget {
  final TextEditingController locationController;

  const ArtifactLocationSection({
    super.key,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📍 Место находки',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: locationController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Место (город, область, памятник)',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: const [
            Icon(Icons.map_outlined, color: Colors.white70),
            SizedBox(width: 8),
            Text('Можно будет добавить геолокацию GPS',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      ],
    );
  }
}
