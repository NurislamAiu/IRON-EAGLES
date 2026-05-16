import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ArcheoAI/features/artifacts/domain/expedition_model.dart';
import 'package:ArcheoAI/features/artifacts/provider/expedition_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../../core/localization/app_localizations.dart';

class ExpeditionTab extends StatelessWidget {
  const ExpeditionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpeditionProvider>();
    final expeditions = provider.myExpeditions;
    final userEmail = context.read<AuthProviders>().user?.email ?? "";

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
          label: Text(
            S.of(context).newExpedition,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            expandedHeight: 110,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).expeditions,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    S.of(context).yourProjects,
                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: expeditions.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState(context))
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.orange.shade800.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.4, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                ),
                child: const Icon(Icons.travel_explore_rounded, size: 60, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            S.of(context).noProjects,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              S.of(context).createProjectMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpeditionCard(BuildContext context, Expedition expedition) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
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
                // Заголовок и меню
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
                                "${S.of(context).start}: ${DateFormat('dd.MM.yyyy').format(expedition.startDate)}",
                                style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Меню опций
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
                      color: const Color(0xff2a2422),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      offset: const Offset(0, 40),
                      onSelected: (value) {
                        if (value == 'invite') _showInviteDialog(context, expedition.id);
                        if (value == 'delete') _showDeleteConfirm(context, expedition);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'invite',
                          child: Row(
                            children: [
                              const Icon(Icons.person_add_rounded, color: Colors.orangeAccent, size: 20),
                              const SizedBox(width: 12),
                              Text(S.of(context).invite, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 12),
                              Text(S.of(context).delete, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Описание
                Text(
                  expedition.description.isNotEmpty ? expedition.description : S.of(context).noDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 24),
                // Нижняя панель
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMembersStack(context, expedition.memberEmails),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade700.withOpacity(0.2),
                        foregroundColor: Colors.cyanAccent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () => context.push('/expedition-chat', extra: expedition),
                      icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                      label: Text(S.of(context).chat, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildMembersStack(BuildContext context, List<String> emails) {
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
        Text(
          S.of(context).participants,
          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getAvatarColor(String email) {
    final colors = [
      Colors.orange.shade700,
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.purple.shade700,
      Colors.pink.shade700,
      Colors.teal.shade700,
    ];
    return colors[email.hashCode % colors.length];
  }

  void _showDeleteConfirm(BuildContext context, Expedition expedition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1f1a18),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.warning_rounded, color: Colors.redAccent),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(S.of(context).deleteProject, style: const TextStyle(color: Colors.white, fontSize: 20))),
          ],
        ),
        content: Text(
          "${S.of(context).deleteProjectConfirm} '${expedition.name}'? ${S.of(context).cannotUndo}",
          style: const TextStyle(color: Colors.white70, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel, style: const TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<ExpeditionProvider>().deleteExpedition(expedition.id);
              Navigator.pop(context);
            },
            child: Text(S.of(context).deleteAction, style: const TextStyle(fontWeight: FontWeight.bold)),
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
        backgroundColor: const Color(0xff1f1a18),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Text(S.of(context).inviteColleague, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).inviteEmailLabel,
              style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                labelText: S.of(context).emailLabel,
                labelStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.orangeAccent)),
                prefixIcon: const Icon(Icons.alternate_email_rounded, color: Colors.orangeAccent),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel, style: const TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<ExpeditionProvider>().inviteMember(
                  expeditionId,
                  emailController.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(S.of(context).inviteSent),
                      ],
                    ),
                    backgroundColor: Colors.green.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              }
            },
            child: Text(S.of(context).invite, style: const TextStyle(fontWeight: FontWeight.bold)),
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
        backgroundColor: const Color(0xff1f1a18),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Text(S.of(context).startExpedition, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.orangeAccent,
                validator: (value) => (value == null || value.isEmpty) ? S.of(context).enterName : null,
                decoration: InputDecoration(
                  labelText: S.of(context).projectName,
                  labelStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.orangeAccent)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.orangeAccent,
                decoration: InputDecoration(
                  labelText: S.of(context).projectDescription,
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.orangeAccent)),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel, style: const TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            child: Text(S.of(context).create, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
