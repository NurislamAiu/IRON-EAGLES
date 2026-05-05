import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../blogs/provider/blog_provider.dart';
import '../../blogs/domain/blog_post_model.dart';
import 'add_blog_tab.dart';

class BlogFeedTab extends StatelessWidget {
  const BlogFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BlogProvider>();
    final blogs = provider.blogs;
    final user = context.watch<AuthProviders>().user;
    final isResearcher = user != null; // Archaeologists and Admins can post

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: isResearcher
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade800,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const Scaffold(
                          extendBodyBehindAppBar: true,
                          backgroundColor: Color(0xff2c1e19),
                          body: AddBlogTab(),
                        )),
              ),
              icon: const Icon(Icons.add_comment, color: Colors.white),
              label: const Text("Написать",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            title: Text(
              "Блог исследователей",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: provider.isLoading
                ? const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.orangeAccent)))
                : blogs.isEmpty
                    ? _buildEmptyState()
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildBlogCard(context, blogs[index]),
                          childCount: blogs.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.article_outlined, size: 80, color: Colors.white10),
            SizedBox(height: 16),
            Text("Пока нет новых записей",
                style: TextStyle(color: Colors.white38, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, BlogPost blog) {
    final user = context.watch<AuthProviders>().user;
    final userEmail = user?.email ?? '';
    final isLiked = blog.likes.contains(userEmail);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.imageUrl.isNotEmpty)
                Image.network(
                  blog.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 14, color: Colors.orangeAccent),
                        const SizedBox(width: 4),
                        Text(blog.authorEmail,
                            style: const TextStyle(
                                color: Colors.orangeAccent, fontSize: 12)),
                        const Spacer(),
                        Text(
                          DateFormat('dd MMM yyyy').format(blog.createdAt),
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      blog.content,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (userEmail.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Пожалуйста, войдите в систему')),
                              );
                              return;
                            }
                            context.read<BlogProvider>().toggleLike(blog.id, userEmail);
                          },
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.redAccent : Colors.white,
                          ),
                        ),
                        Text(
                          '${blog.likes.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _showCommentsSheet(context, blog),
                          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                        ),
                        Text(
                          '${blog.comments.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, BlogPost blog) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff2c1e19),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Комментарии",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<BlogProvider>(
                    builder: (context, provider, child) {
                      final currentBlog = provider.blogs.firstWhere(
                          (b) => b.id == blog.id,
                          orElse: () => blog);
                      if (currentBlog.comments.isEmpty) {
                        return const Center(
                          child: Text(
                            "Пока нет комментариев",
                            style: TextStyle(color: Colors.white38),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: currentBlog.comments.length,
                        itemBuilder: (context, index) {
                          final comment = currentBlog.comments[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              comment.authorEmail,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            subtitle: Text(
                              comment.content,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            trailing: Text(
                              DateFormat('dd MMM').format(comment.createdAt),
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 12),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                _CommentInputField(blogId: blog.id),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CommentInputField extends StatefulWidget {
  final String blogId;
  const _CommentInputField({required this.blogId});

  @override
  State<_CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<_CommentInputField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Написать комментарий...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                final user = context.read<AuthProviders>().user;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, войдите в систему')));
                  return;
                }
                context.read<BlogProvider>().addComment(
                    widget.blogId, _controller.text.trim(), user.email ?? 'Unknown');
                _controller.clear();
              }
            },
            icon: const Icon(Icons.send, color: Colors.orangeAccent),
          ),
        ],
      ),
    );
  }
}
