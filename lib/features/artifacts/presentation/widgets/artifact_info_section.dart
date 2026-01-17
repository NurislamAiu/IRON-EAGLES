import 'package:flutter/material.dart';

class ArtifactInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController periodController;

  const ArtifactInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.categoryController,
    required this.periodController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Основная информация',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),

        _field(titleController, 'Название артефакта'),
        const SizedBox(height: 12),

        _field(descriptionController, 'Описание', maxLines: 3),
        const SizedBox(height: 12),

        _field(categoryController, 'Категория (керамика, металл, оружие...)'),
        const SizedBox(height: 12),

        _field(periodController, 'Период / век (например: XII век до н.э.)'),
      ],
    );
  }

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }
}
