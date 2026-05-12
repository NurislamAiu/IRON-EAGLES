import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/flash_message.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/course_provider.dart';
import '../provider/currency_provider.dart';
import '../domain/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final _priceController = TextEditingController();

  void _buyCourse() {
    final email = context.read<AuthProviders>().user?.email;
    if (email == null) {
      FlashMessage.info(context, "Нужно войти в аккаунт");
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        title: const Text("Подтверждение оплаты", style: TextStyle(color: Colors.white)),
        content: Text("Списать ${context.read<CurrencyProvider>().formatPrice(widget.course.price)} за этот курс?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<CourseProvider>().buyCourse(widget.course.id, email);
                if (mounted) FlashMessage.success(context, "Курс успешно оплачен!");
                if (mounted) context.pop(); // go back to refresh
              } catch (e) {
                if (mounted) FlashMessage.error(context, "Ошибка оплаты");
              }
            },
            child: const Text("Оплатить", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editPrice() {
    _priceController.text = widget.course.price.toString();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        title: const Text("Изменить стоимость", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Новая цена (в USD)",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () async {
              final newPrice = double.tryParse(_priceController.text) ?? 0.0;
              Navigator.pop(context);
              try {
                await context.read<CourseProvider>().updatePrice(widget.course.id, newPrice);
                if (mounted) FlashMessage.success(context, "Стоимость обновлена!");
                if (mounted) context.pop(); // go back to refresh
              } catch (e) {
                if (mounted) FlashMessage.error(context, "Ошибка изменения");
              }
            },
            child: const Text("Сохранить", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = context.watch<AuthProviders>().user?.email ?? "";
    final isAuthor = widget.course.authorEmail == userEmail;
    final isBought = widget.course.price == 0 || widget.course.purchasedBy.contains(userEmail) || isAuthor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isAuthor)
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.white),
              tooltip: "Изменить цену",
              onPressed: _editPrice,
            )
        ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Автор: ${widget.course.authorEmail}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  
                  if (!isBought) ...[
                    // Not bought
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.white54, size: 60),
                          const SizedBox(height: 16),
                          const Text(
                            "Этот курс платный",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Оплатите ${context.watch<CurrencyProvider>().formatPrice(widget.course.price)}, чтобы получить доступ к материалам курса.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _buyCourse,
                            child: const Text("Купить доступ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    )
                  ] else ...[
                    // Bought or Free or Author
                    const Text(
                      "Описание курса",
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.course.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Материалы",
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.course.content,
                        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}