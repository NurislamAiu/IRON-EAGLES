import 'dart:ui';
import 'package:flutter/material.dart';
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

  final filters = ['Все', 'Керамика', 'Металл', 'Украшения', 'Монеты'];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _pageController = PageController(viewportFraction: 0.82);

    Future.microtask(() => context.read<ArtifactProvider>().fetchArtifacts());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final artifacts = provider.artifacts;

    final filtered = artifacts.where((a) {
      final q = _search.toLowerCase().trim();

      // 🔍 Поиск по ID (фикс)
      final matchesId = (a.id ?? "").toString().toLowerCase().contains(q);

      // 🔍 Поиск по названию
      final matchesTitle = a.title.toLowerCase().contains(q);

      // 🔍 Поиск по описанию
      final matchesDescription = a.description.toLowerCase().contains(q);

      // 🔍 Поиск по категории
      final matchesCategorySearch = (a.category ?? "").toLowerCase().contains(
        q,
      );

      // 🔍 Поиск по материалу
      final matchesMaterial = (a.material ?? "").toLowerCase().contains(q);

      // 🔍 Поиск по периоду
      final matchesPeriod = (a.period ?? "").toLowerCase().contains(q);

      // Итоговое правило: если любое совпадает — артефакт подходит
      final searchMatch =
          q.isEmpty ||
          matchesId ||
          matchesTitle ||
          matchesDescription ||
          matchesCategorySearch ||
          matchesMaterial ||
          matchesPeriod;

      // Фильтр по категории ("Все" = без фильтра)
      if (_selectedFilter == "Все") return searchMatch;

      final filterMatch =
          (a.category ?? "").toLowerCase() == _selectedFilter.toLowerCase();

      return searchMatch && filterMatch;
    }).toList();

    final featured = filtered.take(5).toList();

    return FadeTransition(
      opacity: _fade,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _buildHeader(),
                const SizedBox(height: 12),

                _buildSearch(),

                const SizedBox(height: 12),
                _buildFilterChips(),

                const SizedBox(height: 18),

                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: featured.length,
                    itemBuilder: (_, i) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (_, child) {
                          double value = 0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - i;
                            value = (1 - (value.abs() * 0.3)).clamp(0.75, 1.0);
                          }
                          return Transform.scale(
                            scale: Curves.easeOut.transform(value),
                            child: child,
                          );
                        },
                        child: _buildHeroCard(featured[i]),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Артефакты"),

                ListView.builder(
                  itemCount: filtered.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, i) => _buildListCard(filtered[i]),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "MuseumCode — цифровой музей",
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          hintText: "Поиск по артефактам...",
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: filters.length,
        itemBuilder: (_, i) {
          final f = filters[i];
          final selected = f == _selectedFilter;

          return ChoiceChip(
            label: Text(f),
            selected: selected,
            onSelected: (_) => setState(() => _selectedFilter = f),
            selectedColor: Colors.brown.shade400,
            backgroundColor: Colors.white.withOpacity(0.1),
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black,
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
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Positioned.fill(
                child: a.imageUrl.isNotEmpty
                    ? Image.network(a.imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: Colors.brown.shade700,
                        child: const Icon(
                          Icons.museum_rounded,
                          color: Colors.white70,
                          size: 80,
                        ),
                      ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  a.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.5),
                  ),

                  child: Text(
                    a.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildListCard(Artifact a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: a)),
      ),
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.10),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: a.imageUrl.isNotEmpty
                      ? Image.network(
                          a.imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          color: Colors.brown.shade700,
                          child: const Icon(
                            Icons.museum_rounded,
                            color: Colors.white70,
                            size: 46,
                          ),
                        ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  left: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.5),
                    ),

                    child: Text(
                      a.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      a.category ?? "Категория не указана",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.brown.shade200,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      a.description,
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

            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
