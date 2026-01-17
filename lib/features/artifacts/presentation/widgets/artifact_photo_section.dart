import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArtifactPhotoSection extends StatefulWidget {
  final File? imageFile;             // mobile
  final Uint8List? imageBytes;       // web

  final Function(File file) onImagePickedMobile;
  final Function(Uint8List bytes) onImagePickedWeb;

  const ArtifactPhotoSection({
    super.key,
    required this.imageFile,
    required this.imageBytes,
    required this.onImagePickedMobile,
    required this.onImagePickedWeb,
  });

  @override
  State<ArtifactPhotoSection> createState() => _ArtifactPhotoSectionState();
}

class _ArtifactPhotoSectionState extends State<ArtifactPhotoSection> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    // 📱 MOBILE mode: use File()
    if (!kIsWeb) {
      widget.onImagePickedMobile(File(picked.path));
      return;
    }

    // 🌐 WEB mode: we must load bytes
    final bytes = await picked.readAsBytes();
    widget.onImagePickedWeb(bytes);
  }

  Widget _buildPreview() {
    // 🖼 web preview
    if (kIsWeb && widget.imageBytes != null) {
      return Image.memory(
        widget.imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    }

    // 🖼 mobile preview
    if (!kIsWeb && widget.imageFile != null) {
      return Image.file(
        widget.imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    }

    return const Center(
      child: Icon(
        Icons.add_a_photo_rounded,
        color: Colors.white70,
        size: 48,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📸 Фотография артефакта',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _buildPreview(),
            ),
          ),
        ),
      ],
    );
  }
}
