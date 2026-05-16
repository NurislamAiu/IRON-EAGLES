import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/community_provider.dart';
import '../../blogs/provider/blog_provider.dart';
import '../../blogs/domain/blog_post_model.dart';


import '../../../core/localization/app_localizations.dart';

class CommunityDetailScreen extends StatefulWidget {
  final String communityId;
  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final communityProvider = context.watch<CommunityProvider>();
    final communityIndex = communityProvider.communities.indexWhere((c) => c.id == widget.communityId);
    if (communityIndex == -1) return Scaffold(body: Center(child: Text(S.of(context).noArtifacts))); // Or a more specific message if added
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
              label: Text(S.of(context).publish, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      Text("${community.members.length} ${S.of(context).participantsCount}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                          child: Text(isMember ? S.of(context).leave : S.of(context).join),
                        ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 40, thickness: 1),
                  Text(S.of(context).communityPosts, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (posts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(S.of(context).noPosts, style: const TextStyle(color: Colors.white38)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSimplePostCard(context, posts[index]),
                  childCount: posts.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSimplePostCard(BuildContext context, BlogPost blog) {
    final bool isAdmin = blog.authorEmail.toLowerCase().contains('admin');
    
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          isAdmin ? Icons.campaign : Icons.article,
                          size: 16,
                          color: isAdmin ? Colors.redAccent : Colors.orangeAccent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isAdmin ? S.of(context).officialAnnouncement : S.of(context).clubAnnouncement,
                            style: TextStyle(
                              color: isAdmin ? Colors.redAccent : Colors.orangeAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy').format(blog.createdAt),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (blog.isEdited)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              "(${S.of(context).edited})",
                              style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      blog.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      blog.content, 
                      style: const TextStyle(
                          color: Colors.white70, 
                          fontSize: 15, 
                          height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: Colors.white38),
                        const SizedBox(width: 6),
                        Text(
                          "${S.of(context).publishedBy}: ${blog.authorEmail}",
                          style: const TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.white54, size: 20),
                        const SizedBox(width: 6),
                        Text('${blog.likes.length}', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 20),
                        const SizedBox(width: 6),
                        Text('${blog.comments.length}', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
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
                  Text(S.of(context).newPost, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  labelText: S.of(context).postTitle,
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
                  labelText: S.of(context).postContent,
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
                  child: Text(S.of(context).publish, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
