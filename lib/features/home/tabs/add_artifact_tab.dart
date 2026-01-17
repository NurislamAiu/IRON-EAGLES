import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/flash_message.dart';
import '../../auth/provider/auth_provider.dart';
import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/provider/artifact_provider.dart';
import 'ai_recognition_screen.dart';

class AddArtifactTab extends StatefulWidget {
  const AddArtifactTab({super.key});

  @override
  State<AddArtifactTab> createState() => _AddArtifactTabState();
}

class _AddArtifactTabState extends State<AddArtifactTab>
    with SingleTickerProviderStateMixin {

  // -----------------------------
  // Controllers
  // -----------------------------
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();
  final _category = TextEditingController();
  final _material = TextEditingController();
  final _contextNotes = TextEditingController();

  final _gpsLat = TextEditingController();
  final _gpsLng = TextEditingController();

  final _height = TextEditingController();
  final _width = TextEditingController();
  final _depth = TextEditingController();

  // Dropdowns
  String _condition = "Хорошее состояние";
  String _period = "Не указано";

  XFile? _picked;
  Uint8List? _bytes;

  late AnimationController _fadeController;
  late Animation<double> _fade;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    _category.dispose();
    _material.dispose();
    _contextNotes.dispose();
    _gpsLat.dispose();
    _gpsLng.dispose();
    _height.dispose();
    _width.dispose();
    _depth.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  // Pick image
  // ---------------------------------------------------------
  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;

    _picked = file;

    if (kIsWeb) {
      _bytes = await file.readAsBytes();
    }

    setState(() {});
  }

  // ---------------------------------------------------------
  // Save artifact
  // ---------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_picked == null) {
      FlashMessage.error(context, "Добавьте фото");
      return;
    }

    setState(() => _loading = true);

    final provider = context.read<ArtifactProvider>();
    final user = context.read<AuthProviders>().user;

    double? toNum(String v) {
      if (v.trim().isEmpty) return null;
      return double.tryParse(v.replaceAll(",", "."));
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final artifact = Artifact(
      id: id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      foundLocation: _location.text.trim(),
      imageUrl: "",
      qrCodeUrl: "",
      addedBy: user?.email ?? "unknown",
      createdAt: DateTime.now(),

      category: _category.text.trim(),
      period: _period,
      museumSection: "Общий зал",
      condition: _condition,
      finderId: user?.email ?? "",
      foundDate: DateTime.now(),
      material: _material.text.trim(),
      restorationStatus: "Не требуется",
      contextNotes: _contextNotes.text.trim(),

      height: toNum(_height.text),
      width: toNum(_width.text),
      depth: toNum(_depth.text),

      gpsLat: toNum(_gpsLat.text),
      gpsLng: toNum(_gpsLng.text),
    );

    try {
      await FirebaseFirestore.instance
          .collection("pending_artifacts")
          .doc(artifact.id)
          .set({
        ...artifact.toMap(),
        "imagePending": true,
        "createdAt": DateTime.now(),
        "status": "pending",      // ожидает проверки
      });

// загрузим файл
      final ref = FirebaseStorage.instance
          .ref()
          .child("pending_artifacts/${artifact.id}.jpg");

      if (!kIsWeb) {
        await ref.putFile(File(_picked!.path));
      } else {
        await ref.putData(_bytes!);
      }

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("pending_artifacts")
          .doc(artifact.id)
          .update({"imageUrl": imageUrl});


      FlashMessage.success(context,
          "Артефакт отправлен на модерацию! После одобрения он появится в публикациях.");
      _clearInputs();

    } catch (e) {
      FlashMessage.error(context, "Ошибка: $e");
    }

    setState(() => _loading = false);
  }

  void _clearInputs() {
    _title.clear();
    _description.clear();
    _location.clear();
    _category.clear();
    _material.clear();
    _contextNotes.clear();
    _gpsLat.clear();
    _gpsLng.clear();
    _height.clear();
    _width.clear();
    _depth.clear();
    _picked = null;
    _bytes = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,

          body: FadeTransition(
            opacity: _fade,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 🌟 AI BUTTON
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AIRecognitionScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.auto_awesome, size: 20),
                              label: const Text("AI"),
                            ),
                            const Text(
                              "Добавление артефакта",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),


                            const SizedBox(height: 20),

                            _photoPicker(),

                            const SizedBox(height: 20),

                            _input("Название", _title, icon: Icons.title),
                            _input("Описание", _description,
                                icon: Icons.description, maxLines: 3),
                            _input("Место находки", _location,
                                icon: Icons.location_on),

                            _input("Категория", _category, icon: Icons.category),
                            _dropdownPeriod(),

                            _input("Материал", _material, icon: Icons.texture),
                            _input("Контекст", _contextNotes,
                                maxLines: 2, icon: Icons.note_alt),

                            _dropdownCondition(),

                            const SizedBox(height: 14),
                            _dimensionsGroup(),

                            const SizedBox(height: 14),
                            _gpsGroup(),

                            const SizedBox(height: 30),

                            _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown.shade600,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text(
                                "Сохранить",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------
  // UI PARTS
  // -------------------------

  Widget _photoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: _picked == null
            ? const Center(
            child: Text("Добавить фото",
                style: TextStyle(color: Colors.white70, fontSize: 18)))
            : ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: kIsWeb
              ? Image.memory(_bytes!, fit: BoxFit.cover)
              : Image.file(File(_picked!.path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {int maxLines = 1, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: (v) => v!.trim().isEmpty ? "Заполните поле" : null,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdownPeriod() {
    const items = [
      "Не указано",
      "Каменный век",
      "Бронзовый век",
      "Железный век",
      "Античность",
      "Средневековье",
      "Новое время",
      "Современный период",
    ];

    return _dropdown("Период / Эпоха", _period, items,
            (v) => setState(() => _period = v!));
  }

  Widget _dropdownCondition() {
    const items = [
      "Отличное состояние",
      "Хорошее состояние",
      "Среднее состояние",
      "Плохое состояние",
    ];

    return _dropdown("Состояние", _condition, items,
            (v) => setState(() => _condition = v!));
  }

  Widget _dropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // -------------------------
  // Dimensions block
  // -------------------------
  Widget _dimensionsGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Размеры (см)",
            style: TextStyle(color: Colors.white70, fontSize: 15)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _miniInput("Высота", _height, Icons.height)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Ширина", _width, Icons.width_full)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Глубина", _depth, Icons.view_in_ar)),
          ],
        )
      ],
    );
  }

  // -------------------------
  // GPS block
  // -------------------------
  Widget _gpsGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("GPS координаты",
            style: TextStyle(color: Colors.white70, fontSize: 15)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _miniInput("Широта", _gpsLat, Icons.map)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Долгота", _gpsLng, Icons.explore)),
          ],
        )
      ],
    );
  }

  Widget _miniInput(String label, TextEditingController c, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: c,
          validator: (v) => v!.isEmpty ? "!" : null,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

