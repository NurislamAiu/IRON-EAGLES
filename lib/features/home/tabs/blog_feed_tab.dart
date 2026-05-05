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
                    _ExpandableText(text: blog.content, wordLimit: 25),
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
    final currentUserEmail = context.read<AuthProviders>().user?.email ?? '';
    String? editingCommentId;
    String? editingReplyId;
    String? replyingToCommentId;
    String? inputInitialText;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff2c1e19),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Widget buildCommentMenu(BlogComment comment, {bool isReply = false, String? parentCommentId}) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
                color: const Color(0xff3c2e29),
                onSelected: (value) {
                  if (value == 'edit') {
                    setSheetState(() {
                      if (isReply) {
                        editingReplyId = comment.id;
                        editingCommentId = parentCommentId;
                      } else {
                        editingCommentId = comment.id;
                        editingReplyId = null;
                      }
                      replyingToCommentId = null;
                      inputInitialText = comment.content;
                    });
                  } else if (value == 'delete') {
                    if (isReply) {
                      context.read<BlogProvider>().deleteReply(blog.id, parentCommentId!, comment.id);
                    } else {
                      context.read<BlogProvider>().deleteComment(blog.id, comment.id);
                    }
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text("Изменить", style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text("Удалить", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ];
                },
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
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
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                    title: Text(
                                      comment.authorEmail,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.content,
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 13),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setSheetState(() {
                                              replyingToCommentId = comment.id;
                                              editingCommentId = null;
                                              editingReplyId = null;
                                              inputInitialText = null;
                                            });
                                          },
                                          child: const Text("Ответить", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          DateFormat('dd MMM').format(comment.createdAt),
                                          style: const TextStyle(
                                              color: Colors.white38, fontSize: 12),
                                        ),
                                        if (comment.authorEmail == currentUserEmail)
                                          buildCommentMenu(comment),
                                      ],
                                    ),
                                  ),
                                  if (comment.replies.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40.0),
                                      child: Column(
                                        children: comment.replies.map((reply) {
                                          return ListTile(
                                            leading: const CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.orangeAccent,
                                              child: Icon(Icons.person, color: Colors.white, size: 16),
                                            ),
                                            title: Text(
                                              reply.authorEmail,
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 13),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 4),
                                                Text(
                                                  reply.content,
                                                  style: const TextStyle(
                                                      color: Colors.white70, fontSize: 12),
                                                ),
                                                const SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    setSheetState(() {
                                                      replyingToCommentId = comment.id;
                                                      editingCommentId = null;
                                                      editingReplyId = null;
                                                      inputInitialText = null;
                                                    });
                                                  },
                                                  child: const Text("Ответить", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat('dd MMM').format(reply.createdAt),
                                                  style: const TextStyle(
                                                      color: Colors.white38, fontSize: 11),
                                                ),
                                                if (reply.authorEmail == currentUserEmail)
                                                  buildCommentMenu(reply, isReply: true, parentCommentId: comment.id),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _CommentInputField(
                      blogId: blog.id,
                      editingCommentId: editingCommentId,
                      editingReplyId: editingReplyId,
                      replyingToCommentId: replyingToCommentId,
                      initialText: inputInitialText,
                      onActionFinished: () {
                        setSheetState(() {
                          editingCommentId = null;
                          editingReplyId = null;
                          replyingToCommentId = null;
                          inputInitialText = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}

class _CommentInputField extends StatefulWidget {
  final String blogId;
  final String? editingCommentId;
  final String? editingReplyId;
  final String? replyingToCommentId;
  final String? initialText;
  final VoidCallback onActionFinished;

  const _CommentInputField({
    required this.blogId,
    this.editingCommentId,
    this.editingReplyId,
    this.replyingToCommentId,
    this.initialText,
    required this.onActionFinished,
  });

  @override
  State<_CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<_CommentInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void didUpdateWidget(_CommentInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText) {
      _controller.text = widget.initialText ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditingComment = widget.editingCommentId != null && widget.editingReplyId == null;
    final isEditingReply = widget.editingCommentId != null && widget.editingReplyId != null;
    final isReplying = widget.replyingToCommentId != null;
    final isSpecialAction = isEditingComment || isEditingReply || isReplying;

    String hintText = "Написать комментарий...";
    if (isEditingComment || isEditingReply) hintText = "Изменить...";
    if (isReplying) hintText = "Написать ответ...";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isReplying)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("В ответ на комментарий...", style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
              ),
            ),
          Row(
            children: [
              if (isSpecialAction)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () {
                    _controller.clear();
                    widget.onActionFinished();
                  },
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hintText,
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
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    final user = context.read<AuthProviders>().user;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Пожалуйста, войдите в систему')));
                      return;
                    }
                    
                    if (isEditingReply) {
                      context.read<BlogProvider>().editReply(
                          widget.blogId, widget.editingCommentId!, widget.editingReplyId!, text);
                      widget.onActionFinished();
                    } else if (isEditingComment) {
                      context.read<BlogProvider>().editComment(
                          widget.blogId, widget.editingCommentId!, text);
                      widget.onActionFinished();
                    } else if (isReplying) {
                      context.read<BlogProvider>().addReply(
                          widget.blogId, widget.replyingToCommentId!, text, user.email ?? 'Unknown');
                      widget.onActionFinished();
                    } else {
                      context.read<BlogProvider>().addComment(
                          widget.blogId, text, user.email ?? 'Unknown');
                    }
                    _controller.clear();
                  }
                },
                icon: Icon(isEditingComment || isEditingReply ? Icons.check : Icons.send, color: Colors.orangeAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final int wordLimit;

  const _ExpandableText({required this.text, this.wordLimit = 25});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(RegExp(r'\s+'));
    final isLong = words.length > widget.wordLimit;

    final displayText = (isLong && !isExpanded)
        ? '${words.take(widget.wordLimit).join(' ')}...'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: const TextStyle(
              color: Colors.white70, fontSize: 15, height: 1.5),
        ),
        if (isLong)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
              child: Text(
                isExpanded ? "Скрыть" : "Читать далее...",
                style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }
}
