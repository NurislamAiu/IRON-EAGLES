import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../blogs/provider/blog_provider.dart';
import '../../auth/provider/auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddBlogTab extends StatefulWidget {
  const AddBlogTab({super.key});

  @override
  State<AddBlogTab> createState() => _AddBlogTabState();
}


class _AddBlogTabState extends State<AddBlogTab> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitBlog() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Заполните все поля"),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final email = context.read<AuthProviders>().user?.email ?? "unknown";

    await context.read<BlogProvider>().addBlogPost(
          title: title,
          content: content,
          authorEmail: email,
        );

    setState(() => _isSubmitting = false);
    _titleController.clear();
    _contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Блог успешно опубликован!"),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        backgroundColor: Color(0xff2c1e19),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Новая запись в блог",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Поделитесь вашими мыслями и открытиями с посетителями музея.",
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _titleController,
              label: "Заголовок",
              hint: "Например: Тайны древних гробниц",
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _contentController,
              label: "Содержание",
              hint: "Напишите историю...",
              maxLines: 10,
            ),

            SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: Icon(Icons.attach_file),
              label: Text("Прикрепить файл"),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isSubmitting ? null : _submitBlog,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Опубликовать",
                        style: TextStyle(
                            color: Color(0xff2c1e19),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.orangeAccent, fontSize: 14),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
