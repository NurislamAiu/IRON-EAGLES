import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../auth/provider/auth_provider.dart';
import '../../auth/provider/safety_provider.dart';
import '../provider/community_provider.dart';
import '../domain/community_model.dart';
import 'create_community_screen.dart';
import 'community_detail_screen.dart';

class CommunitiesTab extends StatefulWidget {
  const CommunitiesTab({super.key});

  @override
  State<CommunitiesTab> createState() => _CommunitiesTabState();
}

class _CommunitiesTabState extends State<CommunitiesTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final user = context.watch<AuthProviders>().user;
    final userEmail = user?.email ?? '';
    final isResearcher = userEmail.isNotEmpty;

    final communities = _searchQuery.isEmpty 
        ? provider.communities 
        : provider.searchCommunities(_searchQuery);

    final myCommunities = _searchQuery.isEmpty ? provider.getMyCommunities(userEmail) : <Community>[];
    final otherCommunities = _searchQuery.isEmpty 
        ? communities.where((c) => !myCommunities.contains(c)).toList()
        : communities;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: isResearcher
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade800,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateCommunityScreen(),
                ),
              ),
              icon: const Icon(Icons.group_add, color: Colors.white),
              label: const Text("Создать",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              "Сообщества",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Поиск сообществ...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: _searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white38),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),

          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
            )
          else if (communities.isEmpty && _searchQuery.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search_off, size: 80, color: Colors.white10),
                    SizedBox(height: 16),
                    Text("Ничего не найдено", style: TextStyle(color: Colors.white38, fontSize: 18)),
                  ],
                ),
              ),
            )
          else ...[
            if (myCommunities.isNotEmpty && _searchQuery.isEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Text("Мои сообщества", style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCommunityCard(context, myCommunities[index]),
                    childCount: myCommunities.length,
                  ),
                ),
              ),
            ],

            if (otherCommunities.isNotEmpty || _searchQuery.isNotEmpty) ...[
              if (_searchQuery.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Text("Все сообщества", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCommunityCard(context, otherCommunities[index]),
                    childCount: otherCommunities.length,
                  ),
                ),
              ),
            ]
          ],
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Community community) {
    final safety = context.watch<UserSafetyProvider>();
    if (safety.isBlocked(community.creatorEmail)) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CommunityDetailScreen(communityId: community.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xff1a1412),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (community.imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: community.imageUrl,
                  height: 110,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 110,
                    width: 100,
                    color: Colors.white.withOpacity(0.05),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 110,
                    width: 100,
                    color: Colors.white.withOpacity(0.05),
                    child: const Icon(Icons.image_not_supported, color: Colors.white24, size: 40),
                  ),
                )
              else
                Container(
                  height: 110,
                  width: 100,
                  color: Colors.white.withOpacity(0.05),
                  child: const Icon(Icons.groups, color: Colors.white24, size: 40),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        community.description,
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 14, color: Colors.orangeAccent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${community.members.length} участников",
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
