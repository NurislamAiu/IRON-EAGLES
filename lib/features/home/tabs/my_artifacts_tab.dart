import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:museumcode/core/widgets/flash_message.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/presentation/edit_artifact_screen.dart';
import '../../artifacts/provider/artifact_provider.dart';
import '../../auth/provider/auth_provider.dart';

class MyArtifactsTab extends StatelessWidget {
  const MyArtifactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final email = context.read<AuthProviders>().user?.email ?? "";
    final List<Artifact> myArtifacts = provider.artifacts
        .where((a) => a.addedBy == email)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 10),

        const Text(
          "Мои находки",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        if (myArtifacts.isEmpty)
          _emptyState()
        else
          ...myArtifacts.map((a) => _artifactCard(context, a)).toList(),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _artifactCard(BuildContext context, Artifact a) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.10)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: a.imageUrl.isNotEmpty
                      ? Image.network(
                          a.imageUrl,
                          width: 110,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 110,
                          height: 160,
                          color: Colors.brown.shade700,
                          child: const Icon(
                            Icons.museum_rounded,
                            color: Colors.white70,
                            size: 45,
                          ),
                        ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 14,
                            color: Colors.brown.shade200,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              a.category,
                              style: TextStyle(
                                color: Colors.brown.shade200,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: Text(
                          a.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _editStatusButton(context, a),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editStatusButton(BuildContext context, Artifact a) {
    final email = context.watch<AuthProviders>().user?.email ?? "";

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("pending_artifacts")
          .where("addedBy", isEqualTo: email)
          .where("id", isEqualTo: a.id)
          .snapshots(),
      builder: (context, snapshot) {
        final isPendingPublication =
            snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        /// 1️⃣ Если артефакт находится в pending_artifacts — он НЕ опубликован
        if (isPendingPublication) {
          return _pendingPublicationBadge();
        }

        /// 2️⃣ Артефакт опубликован → проверяем статус редактирования
        return _editModerationStatus(context, a, email);
      },
    );
  }

  Widget _pendingPublicationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue.withOpacity(0.18),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.hourglass_empty, color: Colors.lightBlueAccent, size: 18),
          SizedBox(width: 8),
          Text(
            "Ожидает (публикация)",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _editModerationStatus(BuildContext context, Artifact a, String email) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("edit_requests")
          .where("artifactId", isEqualTo: a.id)
          .where("requestedBy", isEqualTo: email)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox(height: 40);

        final docs = snap.data!.docs;

        // Нет запросов — показать кнопку запроса редактирования
        if (docs.isEmpty) {
          return _requestEditButton(context, a);
        }

        final status = docs.first["status"];

        switch (status) {
          case "pending":
            return _pendingEditBadge();
          case "rejected":
            return _rejectedEditBadge();
          case "approved":
            return _editButton(context, a);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }


  Widget _pendingEditBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.orange.withOpacity(0.18),
        border: Border.all(color: Colors.orange.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.access_time_filled, color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Text(
            "Ожидает (ред.)",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  Widget _rejectedEditBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red.withOpacity(0.18),
        border: Border.all(color: Colors.redAccent.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.close, color: Colors.redAccent, size: 18),
          SizedBox(width: 8),
          Text(
            "Редактирование отклонено",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  Widget _requestEditButton(BuildContext context, Artifact a) {
    final email = context.read<AuthProviders>().user?.email ?? "";

    return GestureDetector(
      onTap: () async {
        await FirebaseFirestore.instance.collection("edit_requests").add({
          "artifactId": a.id,
          "requestedBy": email,
          "status": "pending",
          "createdAt": DateTime.now(),
        });

        FlashMessage.success(context, 'Запрос отправлен модерации');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade700.withOpacity(0.85),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.edit, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              "Редактирование",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, Artifact a) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditArtifactScreen(artifact: a)),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade600.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Редактировать",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.inventory_2_outlined,
          size: 70,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(height: 12),
        Text(
          "У вас пока нет артефактов",
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 17),
        ),
      ],
    );
  }
}
