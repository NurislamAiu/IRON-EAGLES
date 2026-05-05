import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:museumcode/features/artifacts/domain/expedition_model.dart';
import 'package:museumcode/features/artifacts/provider/expedition_provider.dart';
import 'package:museumcode/features/auth/provider/auth_provider.dart';

class ExpeditionTab extends StatelessWidget {
  const ExpeditionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpeditionProvider>();
    final expeditions = provider.myExpeditions;
    final userEmail = context.read<AuthProviders>().user?.email ?? "";

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange.shade800,
        elevation: 8,
        onPressed: () => _showCreateDialog(context, userEmail),
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text(
          "Новая экспедиция", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            title: Text(
              "Экспедиции",
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: expeditions.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildExpeditionCard(context, expeditions[index]),
                      childCount: expeditions.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
            child: const Icon(Icons.explore_outlined, size: 100, color: Colors.white24),
          ),
          const SizedBox(height: 24),
          const Text(
            "У вас пока нет активных экспедиций",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            "Начните проект или присоединитесь к коллегам",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildExpeditionCard(BuildContext context, Expedition expedition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        expedition.name,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 22
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.cyanAccent, size: 28),
                      onPressed: () => context.push('/expedition-chat', extra: expedition),
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_add_alt_1, color: Colors.orangeAccent, size: 28),
                      onPressed: () => _showInviteDialog(context, expedition.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                      onPressed: () => _showDeleteConfirm(context, expedition),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  expedition.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildInfoChip(Icons.people_outline, "${expedition.memberEmails.length} участников"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.calendar_today_outlined, "Старт: ${expedition.startDate.year}"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, Expedition expedition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1a1412),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Удалить экспедицию?", style: TextStyle(color: Colors.white)),
        content: Text(
          "Вы уверены, что хотите удалить '${expedition.name}'? Это действие нельзя отменить.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<ExpeditionProvider>().deleteExpedition(expedition.id);
              Navigator.pop(context);
            },
            child: const Text("Удалить", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context, String expeditionId) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1a1412),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Пригласить коллегу", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Введите email археолога, чтобы добавить его в вашу команду.",
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email археолога",
                labelStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white38),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<ExpeditionProvider>().inviteMember(
                  expeditionId,
                  emailController.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Приглашение отправлено!"), backgroundColor: Colors.orange),
                );
              }
            },
            child: const Text("Пригласить", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, String email) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1a1412),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Начать экспедицию", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                validator: (value) => (value == null || value.isEmpty) ? "Введите название" : null,
                decoration: InputDecoration(
                  labelText: "Название проекта*",
                  labelStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Описание (необязательно)",
                  labelStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<ExpeditionProvider>().createExpedition(
                  name: nameController.text,
                  description: descController.text,
                  leaderEmail: email,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Создать", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
