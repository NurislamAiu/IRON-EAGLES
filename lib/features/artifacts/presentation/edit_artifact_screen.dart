import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/flash_message.dart';
import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/provider/artifact_provider.dart';
import '../../auth/provider/auth_provider.dart';

class EditArtifactScreen extends StatefulWidget {
  final Artifact artifact;
  const EditArtifactScreen({super.key, required this.artifact});

  @override
  State<EditArtifactScreen> createState() => _EditArtifactScreenState();
}

class _EditArtifactScreenState extends State<EditArtifactScreen> {
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

  String _condition = "Хорошее состояние";
  String _period = "Не указано";

  XFile? _picked;
  Uint8List? _bytes;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    final a = widget.artifact;

    _title.text = a.title;
    _description.text = a.description;
    _location.text = a.foundLocation;
    _category.text = a.category;
    _material.text = a.material;
    _contextNotes.text = a.contextNotes;

    _gpsLat.text = a.gpsLat?.toString() ?? "";
    _gpsLng.text = a.gpsLng?.toString() ?? "";

    _height.text = a.height?.toString() ?? "";
    _width.text = a.width?.toString() ?? "";
    _depth.text = a.depth?.toString() ?? "";

    // FIX: Делаем безопасные значения для dropdown-меню
    final periodItems = [
      "Не указано",
      "Каменный век",
      "Бронзовый век",
      "Железный век",
      "Античность",
      "Средневековье",
      "Новое время",
      "Современный период",
    ];
    final conditionItems = [
      "Отличное состояние",
      "Хорошее состояние",
      "Среднее состояние",
      "Плохое состояние",
    ];

    String safe(String value, List<String> list) {
      if (list.contains(value)) return value;
      return list.first;
    }

    _period = safe(a.period, periodItems);
    _condition = safe(a.condition, conditionItems);
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
    super.dispose();
  }

  // ---------------------------------------------------------
  // Pick new image (optional)
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
  // Save edited data
  // ---------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final provider = context.read<ArtifactProvider>();
    final user = context.read<AuthProviders>().user;

    double? toNum(String v) {
      if (v.trim().isEmpty) return null;
      return double.tryParse(v.replaceAll(",", "."));
    }

    final updated = Artifact(
      id: widget.artifact.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      foundLocation: _location.text.trim(),
      imageUrl: widget.artifact.imageUrl,
      qrCodeUrl: widget.artifact.qrCodeUrl,
      addedBy: widget.artifact.addedBy,
      createdAt: widget.artifact.createdAt,

      category: _category.text.trim(),
      period: _period,
      museumSection: widget.artifact.museumSection,
      condition: _condition,
      finderId: widget.artifact.finderId,
      foundDate: widget.artifact.foundDate,
      material: _material.text.trim(),
      restorationStatus: widget.artifact.restorationStatus,
      contextNotes: _contextNotes.text.trim(),

      height: toNum(_height.text),
      width: toNum(_width.text),
      depth: toNum(_depth.text),

      gpsLat: toNum(_gpsLat.text),
      gpsLng: toNum(_gpsLng.text),
    );

    try {
      await provider.updateArtifact(
        artifact: updated,
        newImageFile: (!kIsWeb && _picked != null) ? File(_picked!.path) : null,
        newImageBytes: (kIsWeb && _picked != null) ? _bytes : null,
      );

      FlashMessage.success(context, "Артефакт обновлён!");
      Navigator.pop(context);
    } catch (e) {
      FlashMessage.error(context, "Ошибка: $e");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Редактирование", style: TextStyle(color: Colors.white)),
      ),

      body: Stack(
        children: [
          /// ---- BACKGROUND IMAGE ----
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/museum_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),

          /// ---- CONTENT ----
          SingleChildScrollView(
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
                        const Text(
                          "Редактировать артефакт",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),
                        _photoPicker(),
                        const SizedBox(height: 20),

                        _input("Название", _title),
                        _input("Описание", _description, maxLines: 3),
                        _input("Место находки", _location),

                        _input("Категория", _category),
                        _dropdownPeriod(),

                        _input("Материал", _material),
                        _input("Контекст", _contextNotes, maxLines: 2),

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
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            "Сохранить изменения",
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
        ],
      ),
    );
  }


  // -------------------------
  // UI PARTS
  // -------------------------

  Widget _photoPicker() {
    final a = widget.artifact;

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
        child: _picked != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: kIsWeb
              ? Image.memory(_bytes!, fit: BoxFit.cover)
              : Image.file(File(_picked!.path), fit: BoxFit.cover),
        )
            : a.imageUrl.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(a.imageUrl, fit: BoxFit.cover),
        )
            : const Center(
          child: Text(
            "Добавить фото",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: (v) => v!.trim().isEmpty ? "Заполните поле" : null,
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
            Expanded(child: _miniInput("Высота", _height)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Ширина", _width)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Глубина", _depth)),
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
            Expanded(child: _miniInput("Широта", _gpsLat)),
            const SizedBox(width: 12),
            Expanded(child: _miniInput("Долгота", _gpsLng)),
          ],
        )
      ],
    );
  }

  Widget _miniInput(String label, TextEditingController c) {
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
