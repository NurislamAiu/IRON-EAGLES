import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ArcheoAI/core/widgets/flash_message.dart';
import 'package:ArcheoAI/features/artifacts/data/artifact_service.dart';
import 'package:provider/provider.dart';

import '../../artifacts/domain/artifact_model.dart';
import '../../artifacts/presentation/artifact_detail_screen.dart';
import '../../artifacts/provider/artifact_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;
  late PageController _pageController;

  String _search = '';
  String _selectedFilter = 'Все';
  final filters = ['Все', 'Скульптура', 'Стела', 'Украшения', 'Архитектура', 'Манускрипт'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _pageController = PageController(viewportFraction: 0.85);
    Future.microtask(() => context.read<ArtifactProvider>().fetchArtifacts());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _uploadMockData() async {
    try {
      FlashMessage.info(context, "Начинаю загрузку артефактов...");
      await ArtifactService().uploadMockArtifacts();
      FlashMessage.success(context, "Моковые данные успешно загружены!");
      context.read<ArtifactProvider>().fetchArtifacts();
    } catch (e) {
      FlashMessage.error(context, "Ошибка загрузки: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final artifacts = provider.artifacts;

    // Логика фильтрации и поиска
    final filtered = artifacts.where((a) {
      final q = _search.toLowerCase().trim();
      final searchMatch = q.isEmpty ||
          a.id.toLowerCase().contains(q) ||
          a.title.toLowerCase().contains(q) ||
          a.description.toLowerCase().contains(q) ||
          a.category.toLowerCase().contains(q) ||
          a.material.toLowerCase().contains(q) ||
          a.period.toLowerCase().contains(q);
      if (_selectedFilter == "Все") return searchMatch;
      return searchMatch && a.category.toLowerCase().contains(_selectedFilter.toLowerCase());
    }).toList();

    // Для карусели берем первые 5
    final featured = filtered.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 50),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: _buildSearch(),
              ),
            ),
            SliverToBoxAdapter(child: _buildFilterChips()),
            if (featured.isNotEmpty) ...[
              SliverToBoxAdapter(child: _buildSectionTitle("Избранные")),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: featured.length,
                    itemBuilder: (_, i) => _buildHeroCard(featured[i]),
                  ),
                ),
              ),
            ],
            SliverToBoxAdapter(child: _buildSectionTitle("Все Артефакты")),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildListCard(filtered[index]),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Добро пожаловать в",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "ArcheoAI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintText: "Поиск артефактов...",
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (_, i) {
          final f = filters[i];
          final selected = f == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(f),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = f),
              backgroundColor: Colors.white.withOpacity(0.1),
              selectedColor: Colors.white.withOpacity(0.8),
              labelStyle: TextStyle(
                color: selected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(Artifact a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: a)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: a.imageUrl.isEmpty ? Colors.white10 : null,
          image: a.imageUrl.isEmpty ? null : DecorationImage(
            image: a.imageUrl.startsWith('http') 
                ? NetworkImage(a.imageUrl) as ImageProvider
                : AssetImage(a.imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (a.imageUrl.isEmpty)
              const Center(child: Icon(Icons.museum_outlined, size: 60, color: Colors.white24)),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    a.period,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 120,
      height: 130,
      color: Colors.black.withOpacity(0.2),
      child: const Icon(Icons.broken_image, color: Colors.white54),
    );
  }

  Widget _buildListCard(Artifact a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: a)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                    child: a.imageUrl.isEmpty 
                        ? _buildErrorImage()
                        : (a.imageUrl.startsWith('http')
                            ? Image.network(
                                a.imageUrl,
                                width: 120,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildErrorImage(),
                              )
                            : Image.asset(
                                a.imageUrl,
                                width: 120,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildErrorImage(),
                              )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            a.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            a.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.orange.shade300, // Акцент на категорию
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            a.foundLocation,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
