import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // <-- ИСПРАВЛЕНИЕ: Добавлен импорт
import 'package:ArcheoAI/core/utils/generate_random_id.dart';
import 'package:ArcheoAI/core/widgets/flash_message.dart';
import 'package:ArcheoAI/core/widgets/glass_text_field.dart';
import 'package:ArcheoAI/features/artifacts/domain/artifact_model.dart';
import 'package:ArcheoAI/features/artifacts/provider/artifact_provider.dart';
import 'package:ArcheoAI/features/auth/provider/auth_provider.dart'; // <-- ИСПРАВЛЕНИЕ: Добавлен импорт
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';

class AddArtifactTab extends StatefulWidget {
  const AddArtifactTab({super.key});

  @override
  State<AddArtifactTab> createState() => _AddArtifactTabState();
}

class _AddArtifactTabState extends State<AddArtifactTab> {
  // --- STATE ---
  int _currentStep = 0;
  bool _isLoading = false;

  // --- IMAGE DATA ---
  File? _imageFile;
  Uint8List? _imageBytes;
  final _picker = ImagePicker();

  // --- CONTROLLERS ---
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _period = TextEditingController();
  final _material = TextEditingController();
  final _condition = TextEditingController();
  final _foundLocation = TextEditingController();
  final _finderId = TextEditingController();
  DateTime? _foundDate;
  final _height = TextEditingController();
  final _width = TextEditingController();
  final _depth = TextEditingController();
  final _contextNotes = TextEditingController();
  final _museumSection = TextEditingController();
  final _restorationStatus = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    _period.dispose();
    _material.dispose();
    _condition.dispose();
    _foundLocation.dispose();
    _finderId.dispose();
    _height.dispose();
    _width.dispose();
    _depth.dispose();
    _contextNotes.dispose();
    _museumSection.dispose();
    _restorationStatus.dispose();
    super.dispose();
  }

  // --- LOGIC ---
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      if (kIsWeb) {
        _imageBytes = await pickedFile.readAsBytes();
      } else {
        _imageFile = File(pickedFile.path);
      }
      setState(() {});
    }
  }

  void _resetForm() {
    _title.clear();
    _description.clear();
    _category.clear();
    _period.clear();
    _material.clear();
    _condition.clear();
    _foundLocation.clear();
    _finderId.clear();
    _height.clear();
    _width.clear();
    _depth.clear();
    _contextNotes.clear();
    _museumSection.clear();
    _restorationStatus.clear();
    _foundDate = null;
    _imageFile = null;
    _imageBytes = null;
    setState(() => _currentStep = 0);
  }

  Future<void> _saveArtifact() async {
    if (_imageFile == null && _imageBytes == null) {
      FlashMessage.error(context, "Artifact photo is required");
      return;
    }
    if (_title.text.isEmpty || _description.text.isEmpty) {
      FlashMessage.error(context, "Title and description are required");
      return;
    }

    setState(() => _isLoading = true);
    final artifactProvider = context.read<ArtifactProvider>();
    // ИСПРАВЛЕНИЕ: Получаем AuthProvider напрямую из контекста
    final authProvider = context.read<AuthProviders>();
    final user = authProvider.user;

    final artifact = Artifact(
      id: generateArtifactId(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category.text.trim(),
      period: _period.text.trim(),
      material: _material.text.trim(),
      condition: _condition.text.trim(),
      foundLocation: _foundLocation.text.trim(),
      finderId: _finderId.text.trim(),
      foundDate: _foundDate,
      height: double.tryParse(_height.text),
      width: double.tryParse(_width.text),
      depth: double.tryParse(_depth.text),
      contextNotes: _contextNotes.text.trim(),
      museumSection: _museumSection.text.trim(),
      restorationStatus: _restorationStatus.text.trim(),
      addedBy: user?.email ?? 'unknown',
      createdAt: DateTime.now(),
      imageUrl: '',
    );

    try {
      await artifactProvider.addArtifact(
        artifact: artifact,
        imageFile: _imageFile,
        imageBytes: _imageBytes,
      );
      FlashMessage.success(context, "Artifact added successfully!");
      _resetForm();
    } catch (e) {
      FlashMessage.error(context, "Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildStepperIndicator(),
                  const SizedBox(height: 30),
                  _buildStepContent(),
                  const SizedBox(height: 30),
                  _buildNavigationButtons(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      S.of(context).addArtifact,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStepperIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        bool isActive = index <= _currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.orange.shade300 : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.5, 0), 
          end: Offset.zero
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
      child: Container(
        key: ValueKey<int>(_currentStep),
        child: _steps()[_currentStep],
      ),
    );
  }

  List<Widget> _steps() {
    return [
      // --- ШАГ 1: Фото и основа ---
      Column(
        children: [
          _buildImagePicker(),
          const SizedBox(height: 20),
          GlassTextField(controller: _title, hint: '${S.of(context).title}*', icon: Icons.title),
          const SizedBox(height: 16),
          GlassTextField(
            controller: _description,
            hint: '${S.of(context).description}*',
            icon: Icons.description_outlined,
            maxLines: 5,
          ),
        ],
      ),
      // --- ШАГ 2: Детали ---
      Column(
        children: [
          GlassTextField(controller: _category, hint: S.of(context).category, icon: Icons.category_outlined),
          const SizedBox(height: 16),
          GlassTextField(controller: _period, hint: S.of(context).period, icon: Icons.history_edu_outlined),
          const SizedBox(height: 16),
          GlassTextField(controller: _material, hint: S.of(context).material, icon: Icons.handyman_outlined),
          const SizedBox(height: 16),
          GlassTextField(controller: _condition, hint: S.of(context).condition, icon: Icons.verified_outlined),
        ],
      ),
      // --- ШАГ 3: Обнаружение ---
      Column(
        children: [
          GlassTextField(controller: _foundLocation, hint: S.of(context).location, icon: Icons.place_outlined),
          const SizedBox(height: 16),
          GlassTextField(controller: _finderId, hint: S.of(context).foundBy, icon: Icons.person_search_outlined),
          const SizedBox(height: 16),
          _buildDatePicker(),
          const SizedBox(height: 16),
           GlassTextField(controller: _museumSection, hint: S.of(context).museumSection, icon: Icons.maps_home_work_outlined),
        ],
      ),
      // --- ШАГ 4: Размеры и заметки ---
      Column(
        children: [
          Row(
            children: [
              Expanded(child: GlassTextField(controller: _height, hint: S.of(context).height, icon: Icons.straighten_outlined, keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: GlassTextField(controller: _width, hint: S.of(context).width, icon: Icons.swap_horiz_outlined, keyboardType: TextInputType.number)),
               const SizedBox(width: 16),
              Expanded(child: GlassTextField(controller: _depth, hint: S.of(context).depth, icon: Icons.swap_vert_outlined, keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 16),
          GlassTextField(controller: _restorationStatus, hint: S.of(context).restorationStatus, icon: Icons.build_circle_outlined),
          const SizedBox(height: 16),
          GlassTextField(controller: _contextNotes, hint: S.of(context).notes, icon: Icons.note_alt_outlined, maxLines: 4),
        ],
      )
    ];
  }
  
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: (_imageBytes != null || _imageFile != null)
                ? (kIsWeb
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : Image.file(_imageFile!, fit: BoxFit.cover))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined, color: Colors.white70, size: 50),
                      const SizedBox(height: 12),
                      Text(S.of(context).pickPhoto, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _foundDate ?? DateTime.now(),
              firstDate: DateTime(1000),
              lastDate: DateTime.now(),
            );
            if (date != null) setState(() => _foundDate = date);
          },
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Colors.white70),
                const SizedBox(width: 12),
                Text(
                  _foundDate == null ? S.of(context).foundDate : DateFormat('dd.MM.yyyy').format(_foundDate!),
                  style: TextStyle(color: _foundDate == null ? Colors.white70 : Colors.white, fontSize: 16),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка "Назад"
        if (_currentStep > 0)
          ElevatedButton.icon(
            onPressed: () => setState(() => _currentStep--),
            icon: const Icon(Icons.arrow_back),
            label: Text(S.of(context).back),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
          )
        else const SizedBox(), // Пустое место для сохранения разметки

        // Кнопка "Далее" или "Сохранить"
        ElevatedButton.icon(
          onPressed: _currentStep == 3 ? _saveArtifact : () => setState(() => _currentStep++),
          icon: Icon(_currentStep == 3 ? Icons.save_alt_outlined : Icons.arrow_forward),
          label: Text(_currentStep == 3 ? S.of(context).save : S.of(context).next),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
