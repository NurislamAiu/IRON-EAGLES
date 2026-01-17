import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:museumcode/features/artifacts/presentation/widget_detial_screen/comment_input_bar.dart';
import 'package:museumcode/features/artifacts/presentation/widget_detial_screen/comments_section.dart';
import 'package:museumcode/features/artifacts/presentation/widget_detial_screen/glass_card.dart';
import 'package:museumcode/features/artifacts/presentation/widget_detial_screen/info_row.dart';
import 'package:museumcode/features/artifacts/presentation/widget_detial_screen/top_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../auth/provider/auth_provider.dart';
import '../data/comment_service.dart';
import '../domain/artifact_model.dart';

class ArtifactDetailScreen extends StatefulWidget {
  final Artifact artifact;

  const ArtifactDetailScreen({super.key, required this.artifact});

  @override
  State<ArtifactDetailScreen> createState() => _ArtifactDetailScreenState();
}

class _ArtifactDetailScreenState extends State<ArtifactDetailScreen> {
  bool liked = false;

  final TextEditingController commentController = TextEditingController();
  final CommentService commentService = CommentService();

  String _formatDate(dynamic ts) {
    if (ts == null) return "Неизвестно";
    if (ts is DateTime) return DateFormat("dd.MM.yyyy").format(ts);
    try {
      return DateFormat("dd.MM.yyyy").format(ts.toDate());
    } catch (_) {
      return "Неизвестно";
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.artifact;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          _buildDeleteButton(context),
        ],
      ),


      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottom = MediaQuery.of(context).viewInsets.bottom;

          return Stack(
            children: [
              Positioned.fill(child: _background()),

              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.only(bottom: bottom + 70),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      TopImage(url: a.imageUrl),

                      const SizedBox(height: 20),

                      buildFullArtifactInfo(a),

                      const SizedBox(height: 20),

                      CommentsSection(
                        artifactId: a.id,
                        commentService: commentService,
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CommentInputBar(
                  controller: commentController,
                  onSend: _addComment,
                  enabled: context.watch<AuthProviders>().isLoggedIn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/museum_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(color: Colors.black.withOpacity(0.55)),
    );
  }

  Widget buildFullArtifactInfo(Artifact a) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle("Основная информация"),

          if (a.category.isNotEmpty)
            InfoRow(icon: Icons.category, text: "Категория: ${a.category}"),

          if (a.period.isNotEmpty)
            InfoRow(icon: Icons.history_edu, text: "Период: ${a.period}"),

          InfoRow(
            icon: Icons.maps_home_work,
            text: "Раздел музея: ${a.museumSection}",
          ),

          if (a.condition.isNotEmpty)
            InfoRow(icon: Icons.verified, text: "Состояние: ${a.condition}"),

          if (a.material.isNotEmpty)
            InfoRow(icon: Icons.handyman, text: "Материал: ${a.material}"),

          const SizedBox(height: 24),

          _sectionTitle("Обнаружение"),

          if (a.foundLocation.isNotEmpty)
            InfoRow(
              icon: Icons.place,
              text: "Место находки: ${a.foundLocation}",
            ),

          if (a.finderId.isNotEmpty)
            InfoRow(icon: Icons.search, text: "Нашёл: ${a.finderId}"),

          if (a.foundDate != null)
            InfoRow(
              icon: Icons.calendar_month,
              text: "Дата находки: ${_formatDate(a.foundDate)}",
            ),

          if (a.gpsLat != null && a.gpsLng != null)
            InfoRow(icon: Icons.map, text: "GPS: ${a.gpsLat}, ${a.gpsLng}"),

          const SizedBox(height: 24),

          if (a.height != null || a.width != null || a.depth != null) ...[
            _sectionTitle("Размеры"),

            if (a.height != null)
              InfoRow(icon: Icons.straighten, text: "Высота: ${a.height} см"),

            if (a.width != null)
              InfoRow(icon: Icons.swap_horiz, text: "Ширина: ${a.width} см"),

            if (a.depth != null)
              InfoRow(icon: Icons.swap_vert, text: "Глубина: ${a.depth} см"),

            const SizedBox(height: 24),
          ],

          if (a.restorationStatus.isNotEmpty || a.contextNotes.isNotEmpty) ...[
            _sectionTitle("Реставрация"),

            if (a.restorationStatus.isNotEmpty)
              InfoRow(
                icon: Icons.build_circle,
                text: "Статус: ${a.restorationStatus}",
              ),

            if (a.contextNotes.isNotEmpty)
              InfoRow(icon: Icons.notes, text: "Контекст: ${a.contextNotes}"),

            const SizedBox(height: 24),
          ],

          _sectionTitle("Описание"),

          Text(
            a.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 24),

          if (a.qrCodeUrl.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("QR-код"),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(a.qrCodeUrl, height: 160, width: 160),
                ),
                const SizedBox(height: 24),
              ],
            ),

          _sectionTitle("Метаданные"),

          InfoRow(icon: Icons.person, text: "Добавил: ${a.addedBy}"),
          InfoRow(
            icon: Icons.access_time,
            text: "Создано: ${_formatDate(a.createdAt)}",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.brown.shade300,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Future<void> _addComment() async {
    final user = context.read<AuthProviders>().user;

    // ❌ Если не авторизован — не даём писать
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Чтобы оставить комментарий, войдите в аккаунт"),
        ),
      );
      return;
    }

    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final email = user.email ?? "Неизвестный";

    await commentService.addComment(widget.artifact.id, email, text);

    commentController.clear();
  }

  Widget _buildDeleteButton(BuildContext context) {
    final email = context.read<AuthProviders>().user?.email;

    // Только админ может удалять
    if (email != "admin@gmail.com") {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 28),
      onPressed: () => _confirmDelete(context),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Удалить артефакт?"),
        content: const Text(
          "Это действие нельзя отменить. Артефакт исчезнет из базы данных.",
        ),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Удалить"),
            onPressed: () async {
              Navigator.pop(context);
              await _deleteArtifact(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArtifact(BuildContext context) async {
    final id = widget.artifact.id;

    try {
      // Удаляем артефакт
      await FirebaseFirestore.instance
          .collection("artifacts")
          .doc(id)
          .delete();

      // Удаляем комментарии (если хочешь)
      final comments = await FirebaseFirestore.instance
          .collection("comments")
          .where("artifactId", isEqualTo: id)
          .get();

      for (var doc in comments.docs) {
        await doc.reference.delete();
      }

      // Удаляем запросы на редактирование (если есть)
      final editReq = await FirebaseFirestore.instance
          .collection("edit_requests")
          .where("artifactId", isEqualTo: id)
          .get();

      for (var doc in editReq.docs) {
        await doc.reference.delete();
      }

      // Удаляем из moderation_queue (если есть)
      final queue = await FirebaseFirestore.instance
          .collection("moderation_queue")
          .where("artifact.id", isEqualTo: id)
          .get();

      for (var doc in queue.docs) {
        await doc.reference.delete();
      }

      // Сообщение
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Артефакт удалён")),
      );

      Navigator.pop(context); // назад после удаления
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка удаления: $e")),
      );
    }
  }

}
