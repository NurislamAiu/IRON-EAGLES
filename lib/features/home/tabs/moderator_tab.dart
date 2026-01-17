import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:museumcode/core/widgets/flash_message.dart';
import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/presentation/artifact_detail_screen.dart';

class ModeratorTab extends StatelessWidget {
  const ModeratorTab({super.key});

  @override
  Widget build(BuildContext context) {
    print("📌 ModeratorTab OPENED");

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const TabBar(
            tabs: [
              Tab(text: "Публикации"),
              Tab(text: "Редактирование"),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.brown,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PublishRequestsTab(),
                _EditRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =================================================================
///        🟩 TAB 1 — Запросы на публикацию новых артефактов
/// =================================================================

class _PublishRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("🟢 BUILD PublishRequestsTab");

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('moderation_queue')
          .where('status', isEqualTo: 'pending_publish')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        print("📡 STREAM PublishRequestsTab: hasData=${snapshot.hasData}");

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final docs = snapshot.data!.docs;
        print("📥 PUBLISH REQUEST COUNT: ${docs.length}");

        if (docs.isEmpty) {
          return _empty("Нет заявок на публикацию");
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: docs.map((d) {
            print("📄 RAW DOC: ${d.data()}");

            final data = d['data'];
            print("🔍 DATA FIELD: $data");

            Artifact artifact;
            try {
              artifact = Artifact.fromMap(data);
              print("🟩 PARSED ARTIFACT: ${artifact.title}");
            } catch (e) {
              print("❌ ARTIFACT PARSE ERROR: $e");
              return Container(
                padding: const EdgeInsets.all(12),
                color: Colors.red.withOpacity(0.3),
                child: Text("Ошибка парсинга: $e", style: const TextStyle(color: Colors.white)),
              );
            }

            return _moderationCard(
              context: context,
              title: artifact.title,
              subtitle: artifact.category,
              imageUrl: artifact.imageUrl,
              onAccept: () => _publish(context, d.id, artifact),
              onReject: () => _reject(context, d.id),
              onOpen: () {
                print("➡ OPEN ARTIFACT DETAIL: ${artifact.id} | ${artifact.title}");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArtifactDetailScreen(artifact: artifact),
                  ),
                ).then((_) {
                  print("⬅ RETURNED FROM DETAIL");
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _publish(BuildContext context, String docId, Artifact artifact) async {
    print("✔ APPROVING PUBLICATION for ${artifact.id}");

    final fs = FirebaseFirestore.instance;

    await fs.collection('artifacts').doc(artifact.id).set(artifact.toMap());
    await fs.collection('moderation_queue').doc(docId).update({
      "status": "approved",
    });

    FlashMessage.success(context, "Артефакт опубликован!");
  }

  Future<void> _reject(BuildContext context, String docId) async {
    print("❌ REJECTING PUBLICATION: $docId");

    await FirebaseFirestore.instance
        .collection('moderation_queue')
        .doc(docId)
        .update({"status": "rejected"});

    FlashMessage.error(context, "Отклонено");
  }
}

/// =================================================================
///        🟧 TAB 2 — Запросы на редактирование
/// =================================================================

class _EditRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("🟠 BUILD EditRequestsTab");

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("edit_requests")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        print("📡 STREAM EditRequestsTab: hasData=${snapshot.hasData}");

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final docs = snapshot.data!.docs;
        print("✏ EDIT REQUEST COUNT: ${docs.length}");

        if (docs.isEmpty) {
          return _empty("Нет запросов на редактирование");
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: docs.map((d) {
            print("📄 EDIT DOC: ${d.data()}");

            final status = d["status"];
            final artifactId = d["artifactId"];
            final userEmail = d["requestedBy"];

            return InkWell(
              onTap: () async {
                print("➡ TAPPED EDIT REQUEST for artifact $artifactId");

                // Загружаем артефакт из Firestore
                final snap = await FirebaseFirestore.instance
                    .collection("artifacts")
                    .doc(artifactId)
                    .get();

                if (!snap.exists) {
                  print("❌ Artifact not found in artifacts/$artifactId");
                  FlashMessage.error(context, "Артефакт не найден");
                  return;
                }

                try {
                  final artifact = Artifact.fromMap(snap.data()!);
                  print("🟩 Loaded artifact: ${artifact.title}");


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArtifactDetailScreen(artifact: artifact),
                    ),
                  );
                } catch (e) {
                  print("❌ PARSE ERROR: $e");
                  FlashMessage.error(context, "Ошибка данных артефакта");
                }
              },
              child: Card(
                color: Colors.white.withOpacity(0.12),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: const Text(
                    "Запрос на редактирование",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Артефакт ID: $artifactId\nОт: $userEmail\nСтатус: $status",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == "pending") ...[
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.greenAccent),
                          onPressed: () => _approveEdit(d.id, context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => _rejectEdit(d.id, context),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );

          }).toList(),
        );
      },
    );
  }

  Future<void> _approveEdit(String id, BuildContext context) async {
    print("✔ APPROVE EDIT: $id");

    await FirebaseFirestore.instance
        .collection("edit_requests")
        .doc(id)
        .update({"status": "approved"});

    FlashMessage.success(context, "Редактирование разрешено");
  }

  Future<void> _rejectEdit(String id, BuildContext context) async {
    print("❌ REJECT EDIT: $id");

    await FirebaseFirestore.instance
        .collection("edit_requests")
        .doc(id)
        .update({"status": "rejected"});

    FlashMessage.error(context, "Отклонено");
  }
}

/// =================================================================
/// UI HELPERS
/// =================================================================

Widget _empty(String text) {
  print("ℹ EMPTY VIEW: $text");

  return Center(
    child: Text(
      text,
      style: const TextStyle(color: Colors.white54, fontSize: 16),
    ),
  );
}

Widget _moderationCard({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String imageUrl,
  required VoidCallback onAccept,
  required VoidCallback onReject,
  required VoidCallback onOpen,
}) {
  print("📦 BUILD CARD: $title | img: $imageUrl");

  return InkWell(
    onTap: () {
      print("👉 CARD TAPPED: $title");
      onOpen();
    },
    borderRadius: BorderRadius.circular(18),
    child: Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.horizontal(left: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              width: 110,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (c, e, stack) {
                print("❌ IMAGE ERROR: $e");
                return Container(
                  width: 110,
                  height: 140,
                  color: Colors.black26,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Spacer(),

                      IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: Colors.greenAccent),
                        onPressed: () {
                          print("✔ ACCEPT $title");
                          onAccept();
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.cancel,
                            color: Colors.redAccent),
                        onPressed: () {
                          print("❌ REJECT $title");
                          onReject();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
