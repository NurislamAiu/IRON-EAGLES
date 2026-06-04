import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ArcheoAI/core/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/presentation/artifact_detail_screen.dart';
import '../../artifacts/provider/artifact_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fade;
  String _search = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    Future.microtask(() => context.read<ArtifactProvider>().fetchArtifacts());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final s = S.of(context);
    final locale = s.locale;
    final artifacts = provider.artifacts;

    final categories = ['All', ...artifacts.map((a) => a.getDisplayCategory(locale)).toSet().toList()];

    final filtered = artifacts.where((a) {
      final q = _search.toLowerCase().trim();
      final titleMatch = a.getDisplayTitle(locale).toLowerCase().contains(q);
      final searchMatch = q.isEmpty || titleMatch;
      if (_selectedFilter == 'All') return searchMatch;
      return searchMatch && a.getDisplayCategory(locale) == _selectedFilter;
    }).toList();

    final featured = artifacts.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.welcome, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)),
                        const Text("ArcheoAI", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    _buildAiAssistantButton(),
                  ],
                ),
              ),
            ),

            SliverAppBar(
              pinned: true,
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: _buildSearch(s),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDailyQuests(s),
                  _buildFilterChips(categories, s),
                  _buildSectionTitle(s.featured),
                  _buildFeaturedCarousel(featured, locale),
                  const SizedBox(height: 10),
                  _buildSectionTitle(s.allArtifacts),
                ],
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildGlassListCard(filtered[index], locale),
                  childCount: filtered.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyQuests(S s) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                s.dailyQuests,
                style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildQuestItem(s.quest3D, true),
          _buildQuestItem(s.questAI, false),
        ],
      ),
    );
  }

  Widget _buildQuestItem(String title, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, 
               color: isDone ? Colors.greenAccent : Colors.white38, size: 18),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(color: isDone ? Colors.white70 : Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAiAssistantButton() {
    return GestureDetector(
      onTap: () => context.push('/ai-archaeologist'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrangeAccent]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.orangeAccent.withOpacity(0.3), blurRadius: 10)],
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildSearch(S s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.orangeAccent),
                hintText: s.searchHint,
                hintStyle: const TextStyle(color: Colors.white38),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(List<String> categories, S s) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = cat == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat == 'All' ? s.filterAll : cat),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = cat),
              showCheckmark: false,
              backgroundColor: Colors.white.withOpacity(0.05),
              selectedColor: Colors.orangeAccent,
              labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFeaturedCarousel(List<Artifact> featured, Locale locale) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _pageController,
        itemCount: featured.length,
        itemBuilder: (_, i) => _buildHeroCard(featured[i], locale),
      ),
    );
  }

  Widget _buildHeroCard(Artifact a, Locale locale) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: a))),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(a.imageUrl),
              Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.getDisplayTitle(locale), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(a.getDisplayCategory(locale), style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassListCard(Artifact a, Locale locale) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: a))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: SizedBox(width: 110, height: 110, child: _buildImage(a.imageUrl)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(a.getDisplayTitle(locale), maxLines: 1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(a.getDisplayCategory(locale), style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white38, size: 12),
                        const SizedBox(width: 4),
                        Expanded(child: Text(a.getDisplayLocation(locale), maxLines: 1, style: const TextStyle(color: Colors.white38, fontSize: 11))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) return Container(color: Colors.white10);
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
  }
}
