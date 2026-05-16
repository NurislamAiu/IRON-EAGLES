import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ArcheoAI/features/artifacts/domain/expedition_model.dart';
import 'package:ArcheoAI/features/artifacts/provider/expedition_provider.dart';
import 'package:ArcheoAI/features/auth/provider/auth_provider.dart';
import 'package:ArcheoAI/features/blogs/provider/blog_provider.dart';
import 'package:ArcheoAI/features/blogs/domain/blog_post_model.dart';
import 'package:ArcheoAI/features/auth/data/user_service.dart';
import 'package:ArcheoAI/features/artifacts/domain/expedition_invite_model.dart';
import 'package:intl/intl.dart';

class ExpeditionTab extends StatelessWidget {
  const ExpeditionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpeditionProvider>();
    final expeditions = provider.myExpeditions;
    final user = context.watch<AuthProviders>().user;
    final userEmail = (user?.email ?? "").toLowerCase();

    // 🔥 Privacy: Filter expeditions where user is leader or member
    final visibleExpeditions = expeditions.where((e) {
      final isLeader = e.leaderEmail.toLowerCase() == userEmail;
      final isMember = e.memberEmails.any((m) => m.toLowerCase() == userEmail);
      return isLeader || isMember;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade800.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.orange.shade500, Colors.deepOrange.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          onPressed: () => _showCreateDialog(context, userEmail),
          icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
          label: const Text(
            "Новая экспедиция",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchExpeditions(),
        color: Colors.orangeAccent,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              expandedHeight: 80, 
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: const Text(
                  "Экспедиции",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ),
            ),

            // 🔥 Pending Invites Section
            if (userEmail.isNotEmpty)
              StreamBuilder<List<ExpeditionInvite>>(
                stream: provider.streamMyInvites(userEmail),
                builder: (context, snapshot) {
                  final invites = snapshot.data ?? [];
                  if (invites.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                  
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              const Text("НОВЫЕ ПРИГЛАШЕНИЯ", style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...invites.map((invite) => _buildInviteCard(context, invite)),
                        ],
                      ),
                    ),
                  );
                }
              ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: visibleExpeditions.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildExpeditionCard(context, visibleExpeditions[index], userEmail),
                        childCount: visibleExpeditions.length,
                      ),
                    ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: const Icon(Icons.travel_explore_rounded, size: 50, color: Colors.white24),
          ),
          const SizedBox(height: 24),
          const Text(
            "Нет активных проектов",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Создайте проект или дождитесь приглашения.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteCard(BuildContext context, ExpeditionInvite invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Приглашение в проект",
                  style: TextStyle(color: Colors.orangeAccent.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  invite.expeditionName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "от ${invite.inviterEmail}",
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.greenAccent.withOpacity(0.2)),
            icon: const Icon(Icons.check_rounded, color: Colors.greenAccent),
            onPressed: () => context.read<ExpeditionProvider>().acceptInvite(invite),
          ),
          const SizedBox(width: 4),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2)),
            icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
            onPressed: () => context.read<ExpeditionProvider>().declineInvite(invite.id),
          ),
        ],
      ),
    );
  }

  Widget _buildExpeditionCard(BuildContext context, Expedition expedition, String userEmail) {
    final isLeader = expedition.leaderEmail.toLowerCase() == userEmail;
    final isLiked = expedition.likes.contains(userEmail);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.shade400.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.explore_rounded, color: Colors.orangeAccent, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expedition.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Colors.white54, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                "Старт: ${DateFormat('dd.MM.yyyy').format(expedition.startDate)}",
                                style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
                      color: const Color(0xff2a2422),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      offset: const Offset(0, 40),
                      onSelected: (value) {
                        if (value == 'invite') _showInviteDialog(context, expedition, userEmail);
                        if (value == 'edit') _showEditDialog(context, expedition);
                        if (value == 'delete') _showDeleteConfirm(context, expedition);
                        if (value == 'announcement') _showAddAnnouncementDialog(context, expedition.id, userEmail);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'invite',
                          child: Row(
                            children: [
                              Icon(Icons.person_add_rounded, color: Colors.orangeAccent, size: 20),
                              SizedBox(width: 12),
                              Text("Пригласить", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        if (isLeader) ...[
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, color: Colors.cyanAccent, size: 20),
                                SizedBox(width: 12),
                                Text("Изменить", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'announcement',
                            child: Row(
                              children: [
                                Icon(Icons.campaign_rounded, color: Colors.orangeAccent, size: 20),
                                SizedBox(width: 12),
                                Text("Объявление", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                SizedBox(width: 12),
                                Text("Удалить", style: TextStyle(color: Colors.redAccent)),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  expedition.description.isNotEmpty ? expedition.description : "Описание отсутствует...",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: userEmail.isEmpty ? null : () => context.read<ExpeditionProvider>().toggleLike(expedition.id, userEmail),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.redAccent : Colors.white54,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text("${expedition.likes.length}", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMembersStack(expedition.memberEmails),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.campaign_rounded, color: Colors.orangeAccent),
                          onPressed: () => _showAnnouncements(context, expedition.id, userEmail),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade700.withOpacity(0.2),
                            foregroundColor: Colors.cyanAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onPressed: () => context.push('/expedition-chat', extra: expedition),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                          label: const Text("Чат", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersStack(List<String> emails) {
    if (emails.isEmpty) return const SizedBox.shrink();
    final displayCount = emails.length > 3 ? 3 : emails.length;
    final extraCount = emails.length - displayCount;
    return Row(
      children: [
        SizedBox(
          width: (displayCount * 22.0) + (extraCount > 0 ? 32.0 : 14.0),
          height: 36,
          child: Stack(
            children: [
              for (int i = 0; i < displayCount; i++)
                Positioned(
                  left: i * 20.0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getAvatarColor(emails[i]),
                      border: Border.all(color: const Color(0xff1f1a18), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emails[i].isNotEmpty ? emails[i][0].toUpperCase() : "?",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              if (extraCount > 0)
                Positioned(
                  left: displayCount * 20.0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: const Color(0xff1f1a18), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "+$extraCount",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Text("Участники", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _getAvatarColor(String email) {
    final colors = [Colors.orange.shade700, Colors.blue.shade700, Colors.green.shade700, Colors.purple.shade700, Colors.pink.shade700, Colors.teal.shade700];
    return colors[email.hashCode % colors.length];
  }

  void _showDeleteConfirm(BuildContext context, Expedition expedition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1f1a18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: BorderSide(color: Colors.redAccent.withOpacity(0.3))),
        title: const Text("Удалить проект?", style: TextStyle(color: Colors.white, fontSize: 20)),
        content: Text("Вы уверены, что хотите удалить экспедицию '${expedition.name}'?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              context.read<ExpeditionProvider>().deleteExpedition(expedition.id);
              Navigator.pop(context);
            },
            child: const Text("Удалить"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Expedition expedition) {
    final nameCtrl = TextEditingController(text: expedition.name);
    final descCtrl = TextEditingController(text: expedition.description);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff1f1a18),
        title: const Text("Редактировать экспедицию", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MapAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Название", labelStyle: TextStyle(color: Colors.white54))),
            TextField(controller: descCtrl, style: const TextStyle(color: Colors.white), maxLines: 3, decoration: const InputDecoration(labelText: "Описание", labelStyle: TextStyle(color: Colors.white54))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              context.read<ExpeditionProvider>().updateExpedition(expedition.copyWith(name: nameCtrl.text.trim(), description: descCtrl.text.trim()));
              Navigator.pop(ctx);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context, Expedition expedition, String userEmail) {
    final emailController = TextEditingController();
    final userService = UserService();
    List<Map<String, dynamic>> searchResults = [];
    bool isSearching = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xff1f1a18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: BorderSide(color: Colors.white.withOpacity(0.1))),
          title: const Text("Пригласить коллегу", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Найдите археолога по email.", style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) async {
                    if (val.length >= 2) {
                      setState(() => isSearching = true);
                      final results = await userService.searchArchaeologists(val);
                      setState(() { searchResults = results; isSearching = false; });
                    } else {
                      setState(() => searchResults = []);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Email археолога",
                    labelStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.orangeAccent)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.orangeAccent),
                    suffixIcon: isSearching ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent)) : null,
                  ),
                ),
                const SizedBox(height: 12),
                if (searchResults.isNotEmpty)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final userResult = searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.person, color: Colors.orangeAccent),
                          title: Text(userResult['email'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                          onTap: () { emailController.text = userResult['email']; setState(() => searchResults = []); },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена", style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  context.read<ExpeditionProvider>().sendInvite(expedition, emailController.text.trim(), userEmail);
                  Navigator.pop(context);
                }
              },
              child: const Text("Пригласить"),
            ),
          ],
        ),
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
        backgroundColor: const Color(0xff1f1a18),
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
                decoration: InputDecoration(labelText: "Название проекта*", labelStyle: const TextStyle(color: Colors.white38)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: "Описание", labelStyle: const TextStyle(color: Colors.white38)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<ExpeditionProvider>().createExpedition(name: nameController.text, description: descController.text, leaderEmail: email);
                Navigator.pop(context);
              }
            },
            child: const Text("Создать"),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context, String expId, String email) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1f1a18),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Новое объявление", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Заголовок")),
            TextField(controller: contentCtrl, style: const TextStyle(color: Colors.white), maxLines: 5, decoration: const InputDecoration(labelText: "Содержание")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<BlogProvider>().addBlogPost(title: titleCtrl.text.trim(), content: contentCtrl.text.trim(), authorEmail: email, communityId: expId);
                Navigator.pop(ctx);
              },
              child: const Text("Опубликовать"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAnnouncements(BuildContext context, String expId, String userEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1a1412),
      builder: (ctx) {
        final blogProvider = context.watch<BlogProvider>();
        final posts = blogProvider.getCommunityPosts(expId);
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Объявления экспедиции", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white10),
              Expanded(
                child: posts.isEmpty 
                  ? const Center(child: Text("Нет объявлений", style: TextStyle(color: Colors.white38)))
                  : ListView.builder(itemCount: posts.length, itemBuilder: (context, index) => _buildAnnouncementCard(context, posts[index], userEmail)),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, BlogPost post, String userEmail) {
    final isMyPost = post.authorEmail == userEmail;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(post.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              if (isMyPost)
                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => context.read<BlogProvider>().deleteBlogPost(post.id)),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}
