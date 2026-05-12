import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/generate_random_id.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/course_provider.dart';
import '../domain/course_model.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _content = TextEditingController();
  final _price = TextEditingController();
  bool _loading = false;

  Future<void> _create() async {
    final email = context.read<AuthProviders>().user?.email;
    if (email == null) return;

    if (_title.text.isEmpty || _desc.text.isEmpty || _content.text.isEmpty) {
      FlashMessage.error(context, "Заполните все основные поля");
      return;
    }

    setState(() => _loading = true);
    
    final priceVal = double.tryParse(_price.text.trim()) ?? 0.0;

    final newCourse = Course(
      id: generateArtifactId(),
      title: _title.text.trim(),
      description: _desc.text.trim(),
      content: _content.text.trim(),
      authorEmail: email,
      price: priceVal,
      purchasedBy: [],
      createdAt: DateTime.now(),
    );

    try {
      await context.read<CourseProvider>().addCourse(newCourse);
      if (mounted) {
        FlashMessage.success(context, "Курс успешно создан!");
        context.pop();
      }
    } catch (e) {
      if (mounted) FlashMessage.error(context, "Ошибка: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Создать курс', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        GlassTextField(controller: _title, hint: "Название курса", icon: Icons.title),
                        const SizedBox(height: 16),
                        GlassTextField(controller: _desc, hint: "Краткое описание", icon: Icons.short_text),
                        const SizedBox(height: 16),
                        GlassTextField(controller: _price, hint: "Стоимость в USD (0 для бесплатного)", icon: Icons.attach_money),
                        const SizedBox(height: 16),
                        
                        TextField(
                          controller: _content,
                          maxLines: 8,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Основной материал (лекции, тексты)",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        _loading
                            ? const CircularProgressIndicator(color: Colors.orangeAccent)
                            : SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: _create,
                                  child: const Text("Опубликовать", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}