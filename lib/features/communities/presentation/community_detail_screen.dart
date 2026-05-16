import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/community_provider.dart';
import '../../blogs/provider/blog_provider.dart';
import '../../blogs/domain/blog_post_model.dart';
import '../domain/community_model.dart';


class CommunityDetailScreen extends StatefulWidget {
  final String communityId;
  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityProvider = context.watch<CommunityProvider>();
    final communityIndex = communityProvider.communities.indexWhere((c) => c.id == widget.communityId);
    if (communityIndex == -1) return const Scaffold(body: Center(child: Text("Сообщество не найдено")));
    final community = communityProvider.communities[communityIndex];

    final user = context.watch<AuthProviders>().user;
    final userEmail = user?.email ?? '';
    final isMember = community.members.contains(userEmail);
    final isOwner = community.creatorEmail == userEmail;

    final blogProvider = context.watch<BlogProvider>();
    final posts = blogProvider.getCommunityPosts(community.id);

    return Scaffold(
      backgroundColor: const Color(0xff1a1412),
      floatingActionButton: isOwner
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade800,
              onPressed: () => _showAddPostDialog(context, widget.communityId, userEmail),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Объявить", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (isOwner)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (val) {
                    if (val == 'edit') _showEditCommunityDialog(context, community);
                    if (val == 'delete') _showDeleteCommunityConfirm(context, community);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text("Редактировать")),
                    const PopupMenuItem(value: 'delete', child: Text("Удалить сообщество", style: TextStyle(color: Colors.redAccent))),
                  ],
                ),
            ],
            backgroundColor: const Color(0xff2c1e19),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(community.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (community.imageUrl.isNotEmpty)
                    Image.network(community.imageUrl, fit: BoxFit.cover)
                  else
                    Container(color: const Color(0xff3c2e29), child: const Icon(Icons.groups, size: 80, color: Colors.white24)),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [const Color(0xff1a1412), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(community.description, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.orangeAccent, size: 20),
                      const SizedBox(width: 8),
                      Text("${community.members.length} участников", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      // Community Likes
                      GestureDetector(
                        onTap: userEmail.isEmpty ? null : () => communityProvider.toggleLike(community.id, userEmail),
                        child: Row(
                          children: [
                            Icon(
                              community.likes.contains(userEmail) ? Icons.favorite : Icons.favorite_border,
                              color: community.likes.contains(userEmail) ? Colors.redAccent : Colors.white54,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text("${community.likes.length}", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (userEmail.isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMember ? Colors.white10 : Colors.orangeAccent,
                            foregroundColor: isMember ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            if (isMember) {
                              communityProvider.leaveCommunity(community.id, userEmail);
                            } else {
                              communityProvider.joinCommunity(community.id, userEmail);
                            }
                          },
                          child: Text(isMember ? "Покинуть" : "Вступить"),
                        ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 40, thickness: 1),
                  const Text("Записи сообщества", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (posts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text("В этом сообществе пока нет записей.", style: const TextStyle(color: Colors.white38)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSimplePostCard(context, posts[index], userEmail),
                  childCount: posts.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSimplePostCard(BuildContext context, BlogPost blog, String userEmail) {
    final bool isAdmin = blog.authorEmail.toLowerCase().contains('admin');
    final bool isMyPost = blog.authorEmail == userEmail;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xff1a1412),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ]
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: isAdmin ? Colors.redAccent : Colors.orangeAccent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    blog.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isAdmin ? Icons.campaign : Icons.article,
                          size: 16,
                          color: isAdmin ? Colors.redAccent : Colors.orangeAccent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isAdmin ? "ОФИЦИАЛЬНОЕ ОБЪЯВЛЕНИЕ" : "ОБЪЯВЛЕНИЕ КЛУБА",
                            style: TextStyle(
                              color: isAdmin ? Colors.redAccent : Colors.orangeAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        if (isMyPost)
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_horiz, color: Colors.white54, size: 20),
                            onSelected: (val) {
                              if (val == 'edit') _showEditPostDialog(context, blog);
                              if (val == 'delete') context.read<BlogProvider>().deleteBlogPost(blog.id);
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'edit', child: Text("Изменить")),
                              const PopupMenuItem(value: 'delete', child: Text("Удалить", style: TextStyle(color: Colors.redAccent))),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      blog.title,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      blog.content, 
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd.MM.yyyy').format(blog.createdAt),
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        Text(
                          "От: ${blog.authorEmail}",
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Like Post
                    InkWell(
                      onTap: userEmail.isEmpty ? null : () => context.read<BlogProvider>().toggleLike(blog.id, userEmail),
                      child: Row(
                        children: [
                          Icon(
                            blog.likes.contains(userEmail) ? Icons.favorite : Icons.favorite_border,
                            color: blog.likes.contains(userEmail) ? Colors.redAccent : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text('${blog.likes.length}', style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Comments button
                    InkWell(
                      onTap: () => _showComments(context, blog, userEmail),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 20),
                          const SizedBox(width: 6),
                          Text('${blog.comments.length}', style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showEditCommunityDialog(BuildContext context, Community community) {
    final nameCtrl = TextEditingController(text: community.name);
    final descCtrl = TextEditingController(text: community.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        title: const Text("Редактировать сообщество", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Название", labelStyle: TextStyle(color: Colors.white54))),
            TextField(controller: descCtrl, style: const TextStyle(color: Colors.white), maxLines: 3, decoration: const InputDecoration(labelText: "Описание", labelStyle: TextStyle(color: Colors.white54))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              context.read<CommunityProvider>().updateCommunity(
                community.copyWith(name: nameCtrl.text.trim(), description: descCtrl.text.trim())
              );
              Navigator.pop(ctx);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  void _showDeleteCommunityConfirm(BuildContext context, Community community) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        title: const Text("Удалить сообщество?", style: TextStyle(color: Colors.white)),
        content: const Text("Это действие нельзя отменить.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Отмена")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<CommunityProvider>().deleteCommunity(community.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Удалить"),
          ),
        ],
      ),
    );
  }

  void _showEditPostDialog(BuildContext context, BlogPost post) {
    final titleCtrl = TextEditingController(text: post.title);
    final contentCtrl = TextEditingController(text: post.content);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff2c1e19),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Изменить объявление", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Заголовок", labelStyle: TextStyle(color: Colors.white54))),
            TextField(controller: contentCtrl, style: const TextStyle(color: Colors.white), maxLines: 5, decoration: const InputDecoration(labelText: "Содержание", labelStyle: TextStyle(color: Colors.white54))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<BlogProvider>().editBlogPost(post.id, titleCtrl.text, contentCtrl.text);
                Navigator.pop(ctx);
              },
              child: const Text("Сохранить"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext context, BlogPost post, String userEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1a1412),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final currentPost = context.watch<BlogProvider>().getCommunityPosts(post.communityId!).firstWhere((p) => p.id == post.id);
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Комментарии", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white10),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentPost.comments.length,
                    itemBuilder: (context, index) {
                      final comment = currentPost.comments[index];
                      return ListTile(
                        title: Text(comment.authorEmail, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                        subtitle: Text(comment.content, style: const TextStyle(color: Colors.white70)),
                        trailing: userEmail == comment.authorEmail 
                          ? IconButton(icon: const Icon(Icons.delete, size: 16, color: Colors.white24), onPressed: () => context.read<BlogProvider>().deleteComment(post.id, comment.id))
                          : null,
                      );
                    },
                  ),
                ),
                if (userEmail.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(hintText: "Напишите комментарий...", hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.orangeAccent),
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            context.read<BlogProvider>().addComment(post.id, _commentController.text.trim(), userEmail);
                            _commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        }
      ),
    );
  }

  void _showAddPostDialog(BuildContext context, String communityId, String email) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff2c1e19),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Новое объявление", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Заголовок",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Содержание",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (titleCtrl.text.trim().isNotEmpty && contentCtrl.text.trim().isNotEmpty) {
                      context.read<BlogProvider>().addBlogPost(
                        title: titleCtrl.text.trim(), 
                        content: contentCtrl.text.trim(),
                        authorEmail: email,
                        communityId: communityId,
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Опубликовать", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
