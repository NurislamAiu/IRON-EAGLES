import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/flash_message.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/comment_service.dart';
import '../domain/artifact_model.dart';
import '../provider/artifact_provider.dart';
import 'widget_detial_screen/comment_input_bar.dart';
import 'widget_detial_screen/comments_section.dart';

class ArtifactDetailScreen extends StatefulWidget {
  final Artifact artifact;

  const ArtifactDetailScreen({super.key, required this.artifact});

  @override
  State<ArtifactDetailScreen> createState() => _ArtifactDetailScreenState();
}

class _ArtifactDetailScreenState extends State<ArtifactDetailScreen> with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return "Неизвестно";
    DateTime? date;
    if (ts is Timestamp) date = ts.toDate();
    if (ts is DateTime) date = ts;
    return date != null ? DateFormat("dd.MM.yyyy", 'ru').format(date) : "Неизвестно";
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff2c1e19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [_buildDeleteButton(context)],
      ),
      body: Stack(
        children: [
          _buildImageHeader(),
          _buildDraggableInfoSheet(),
          if (_tabController.index == 2)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: CommentInputBar(
                  controller: _commentController,
                  onSend: _addComment,
                  enabled: context.watch<AuthProviders>().isLoggedIn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    final hasImage = widget.artifact.imageUrl.isNotEmpty;
    return Hero(
      tag: 'artifact_${widget.artifact.id}',
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          image: hasImage
              ? DecorationImage(
                  image: NetworkImage(widget.artifact.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Placeholder Icon
            if (!hasImage)
              Center(
                child: Icon(
                  Icons.museum_outlined,
                  color: Colors.white.withOpacity(0.4),
                  size: 100,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============== ИСПРАВЛЕННЫЙ ДИЗАЙН ПАНЕЛИ ==============
  Widget _buildDraggableInfoSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2))),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  _buildGrabber(),
                  _buildHeaderContent(),
                  _buildTabBar(),
                  _buildTabBarView(scrollController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // ==========================================================

  Widget _buildGrabber() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.artifact.title,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              if (widget.artifact.category.isNotEmpty) _buildInfoChip(Icons.category_outlined, widget.artifact.category),
              if (widget.artifact.period.isNotEmpty) _buildInfoChip(Icons.history_edu_outlined, widget.artifact.period),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      tabs: const [
        Tab(text: 'Описание'),
        Tab(text: 'Детали'),
        Tab(text: 'Комментарии'),
      ],
    );
  }

  Widget _buildTabBarView(ScrollController scrollController) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(scrollController),
          _buildDetailsTab(scrollController),
          _buildCommentsTab(scrollController),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(ScrollController sc) {
    return SingleChildScrollView(
      controller: sc,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Text(
        widget.artifact.description,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, height: 1.6),
      ),
    );
  }

  Widget _buildDetailsTab(ScrollController sc) {
    final a = widget.artifact;
    return SingleChildScrollView(
      controller: sc,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Основная информация"),
          if (a.museumSection.isNotEmpty) _buildInfoRow(Icons.maps_home_work, "Раздел музея", a.museumSection),
          if (a.condition.isNotEmpty) _buildInfoRow(Icons.verified_outlined, "Состояние", a.condition),
          if (a.material.isNotEmpty) _buildInfoRow(Icons.handyman_outlined, "Материал", a.material),
          
          _buildSectionTitle("Обнаружение"),
          if (a.finderId.isNotEmpty) _buildInfoRow(Icons.person_search_outlined, "Нашёл", a.finderId),
          if (a.foundDate != null) _buildInfoRow(Icons.calendar_month_outlined, "Дата находки", _formatDate(a.foundDate)),
          if (a.foundLocation.isNotEmpty) _buildInfoRow(Icons.place_outlined, "Место находки", a.foundLocation),

          if (a.height != null || a.width != null || a.depth != null) ...[
            _buildSectionTitle("Размеры"),
            if (a.height != null) _buildInfoRow(Icons.straighten_outlined, "Высота", "${a.height} см"),
            if (a.width != null) _buildInfoRow(Icons.swap_horiz_outlined, "Ширина", "${a.width} см"),
            if (a.depth != null) _buildInfoRow(Icons.swap_vert_outlined, "Глубина", "${a.depth} см"),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCommentsTab(ScrollController sc) {
     return ListView(
      controller: sc,
      children: [
        CommentsSection(
          artifactId: widget.artifact.id,
          commentService: _commentService,
          padding: const EdgeInsets.only(bottom: 120), 
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.orange.shade300, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text("$label:", style: const TextStyle(color: Colors.white70, fontSize: 15)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Future<void> _addComment() async {
    final user = context.read<AuthProviders>().user;
    if (user == null) {
      FlashMessage.info(context, "Чтобы оставить комментарий, войдите в аккаунт");
      return;
    }
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    await _commentService.addComment(widget.artifact.id, user.email ?? "Неизвестный", text);
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  Widget _buildDeleteButton(BuildContext context) {
    final email = context.read<AuthProviders>().user?.email;
    if (email != "admin@gmail.com") return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 28),
      onPressed: () => _confirmDelete(context),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Удалить артефакт?", style: TextStyle(color: Colors.white)),
        content: const Text("Это действие нельзя отменить.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Отмена", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Удалить", style: TextStyle(color: Colors.white)),
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
    try {
      await context.read<ArtifactProvider>().deleteArtifact(widget.artifact.id);
      if (mounted) {
        FlashMessage.success(context, "Артефакт удалён");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) FlashMessage.error(context, "Ошибка удаления: $e");
    }
  }
}
