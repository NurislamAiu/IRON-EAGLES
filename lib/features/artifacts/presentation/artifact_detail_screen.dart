import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ArcheoAI/features/artifacts/domain/expedition_model.dart';
import 'package:ArcheoAI/features/artifacts/provider/expedition_provider.dart';
import 'package:ArcheoAI/features/artifacts/presentation/widget_detial_screen/artifact_journey_map.dart';
import 'package:ArcheoAI/features/artifacts/presentation/widget_detial_screen/artifact_location_map.dart';
import 'package:ArcheoAI/features/artifacts/presentation/widget_detial_screen/time_traveler_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/flash_message.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/comment_service.dart';
import '../domain/artifact_model.dart';
import '../provider/achievement_provider.dart';
import '../provider/artifact_provider.dart';
import '../provider/favorite_provider.dart';
import '../../../core/localization/app_localizations.dart';
import 'widget_detial_screen/comment_input_bar.dart';
import 'widget_detial_screen/comments_section.dart';

class ArtifactDetailScreen extends StatefulWidget {
  final Artifact artifact;

  const ArtifactDetailScreen({super.key, required this.artifact});

  @override
  State<ArtifactDetailScreen> createState() => _ArtifactDetailScreenState();
}

class _ArtifactDetailScreenState extends State<ArtifactDetailScreen> with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();

  bool get _showMapTab => widget.artifact.foundLocation.isNotEmpty;
  bool get _show3dTab => widget.artifact.modelUrl.isNotEmpty;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    int tabCount = 4; // History, Audio, Details, Comments
    if (_showMapTab) tabCount++;
    if (_show3dTab) tabCount++;

    _tabController = TabController(length: tabCount, vsync: this);
    Future.microtask(() => _initTts());
  }

  void _initTts() async {
    await _flutterTts.setLanguage(S.of(context).locale.languageCode == 'ru' ? "ru-RU" : "en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    
    _flutterTts.setStartHandler(() => setState(() => _isPlayingAudio = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isPlayingAudio = false));
    _flutterTts.setCancelHandler(() => setState(() => _isPlayingAudio = false));
    _flutterTts.setErrorHandler((_) => setState(() => _isPlayingAudio = false));
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _tabController.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return S.of(context).unknown;
    DateTime? date;
    if (ts is Timestamp) date = ts.toDate();
    if (ts is DateTime) date = ts;
    return date != null ? DateFormat("dd.MM.yyyy", S.of(context).locale.languageCode).format(date) : S.of(context).unknown;
  }

  Future<void> _toggleAudio() async {
    if (_isPlayingAudio) {
      await _flutterTts.stop();
    } else {
      final text = widget.artifact.getDisplayDescription(S.of(context).locale);
      if (text.isNotEmpty) {
        await _flutterTts.speak(text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final locale = s.locale;

    return Scaffold(
      backgroundColor: const Color(0xff1a1412),
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.artifact.getDisplayTitle(locale),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildQuickInfoChips(locale),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: Container(
                      color: const Color(0xff1a1412),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.orangeAccent,
                        unselectedLabelColor: Colors.white54,
                        indicatorColor: Colors.orangeAccent,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: s.history),
                          const Tab(text: "Audio"),
                          Tab(text: s.details),
                          if (_showMapTab) Tab(text: s.map),
                          if (_show3dTab) const Tab(text: '3D'),
                          Tab(text: s.comments),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildDescriptionTab(),
                _buildAudioGuideTab(),
                _buildDetailsTab(),
                if (_showMapTab) _buildMapTab(),
                if (_show3dTab) _build3dTab(),
                _buildCommentsTab(),
              ],
            ),
          ),
          _buildTopActions(),
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildAudioGuideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orangeAccent.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.headset_rounded, color: Colors.orangeAccent, size: 70),
          ),
          const SizedBox(height: 30),
          const Text(
            "AI Audio Guide",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Слушайте историю этого артефакта",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 32),
                onPressed: () => _flutterTts.stop(),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: _toggleAudio,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                  child: Icon(
                    _isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.white, size: 32),
                onPressed: () => _flutterTts.stop(),
              ),
            ],
          ),
          const SizedBox(height: 40),
          if (_isPlayingAudio)
            const Text(
              "ИИ озвучивает описание...",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 13, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.45,
      backgroundColor: const Color(0xff1a1412),
      elevation: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'artifact_${widget.artifact.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildHeaderImage(),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Color(0xff1a1412),
                    ],
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final hasImage = widget.artifact.imageUrl.isNotEmpty;
    final isNetwork = widget.artifact.imageUrl.startsWith('http');
    if (!hasImage) {
      return Container(
        color: Colors.grey.shade900,
        child: const Icon(Icons.museum_outlined, color: Colors.white24, size: 80),
      );
    }
    return isNetwork
        ? CachedNetworkImage(
            imageUrl: widget.artifact.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.black12),
          )
        : Image.asset(widget.artifact.imageUrl, fit: BoxFit.cover);
  }

  Widget _buildQuickInfoChips(Locale locale) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (widget.artifact.category.isNotEmpty)
            _buildInfoChip(Icons.category_outlined, widget.artifact.getDisplayCategory(locale)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orangeAccent.withOpacity(0.8), size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Row(
              children: [
                Consumer<FavoriteProvider>(
                  builder: (context, favProvider, child) {
                    final isFav = favProvider.isFavorite(widget.artifact);
                    return CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () => favProvider.toggleFavorite(widget.artifact),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                if (context.read<AuthProviders>().user?.email == "admin@gmail.com")
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInput() {
    final commentTabIndex = _tabController.length - 1;
    return ListenableBuilder(
      listenable: _tabController,
      builder: (context, child) {
        if (_tabController.index != commentTabIndex) return const SizedBox.shrink();
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Color(0xff1a1412),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: CommentInputBar(
              controller: _commentController,
              onSend: _addComment,
              enabled: context.watch<AuthProviders>().isLoggedIn,
            ),
          ),
        );
      },
    );
  }

  // --- Вкладки ---

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Text(
        widget.artifact.getDisplayDescription(S.of(context).locale),
        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 17, height: 1.7),
      ),
    );
  }

  Widget _buildDetailsTab() {
    final a = widget.artifact;
    final locale = S.of(context).locale;
    final s = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(s.mainInfo),
          if (a.museumSection.isNotEmpty) _buildDetailRow(Icons.maps_home_work_outlined, s.museumSection, a.getDisplayMuseumSection(locale)),
          if (a.condition.isNotEmpty) _buildDetailRow(Icons.verified_outlined, s.condition, a.getDisplayCondition(locale)),
          if (a.material.isNotEmpty) _buildDetailRow(Icons.handyman_outlined, s.material, a.getDisplayMaterial(locale)),
          
          _buildSectionHeader(s.discovery),
          _buildExpeditionCard(),
          if (a.foundDate != null) _buildDetailRow(Icons.calendar_month_outlined, s.foundDate, _formatDate(a.foundDate)),
          if (a.foundLocation.isNotEmpty) _buildDetailRow(Icons.place_outlined, s.location, a.getDisplayLocation(locale)),

          if (a.height != null || a.width != null || a.depth != null) ...[
            _buildSectionHeader(s.dimensions),
            _buildDetailRow(Icons.straighten_outlined, s.height, "${a.height} cm"),
            _buildDetailRow(Icons.swap_horiz_outlined, s.width, "${a.width} cm"),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent.withOpacity(0.7), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildExpeditionCard() {
    final expId = widget.artifact.expeditionId;
    if (expId == null) return const SizedBox.shrink();

    final expeditions = context.read<ExpeditionProvider>().myExpeditions;
    final expedition = expeditions.firstWhere((e) => e.id == expId, orElse: () => Expedition(
      id: '', name: 'Official Expedition', description: '', leaderEmail: '', memberEmails: [], startDate: DateTime.now()
    ));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(expeditions.any((e) => e.id == expId) ? expedition.name : S.of(context).officialExpedition, 
                   style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    final a = widget.artifact;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: a.originLat != null && a.gpsLat != null
            ? ArtifactJourneyMap(
                startLat: a.originLat!, startLng: a.originLng!, startName: a.originName,
                endLat: a.gpsLat!, endLng: a.gpsLng!, endName: a.foundLocation,
              )
            : ArtifactLocationMap(location: a.foundLocation, latitude: a.gpsLat, longitude: a.gpsLng),
      ),
    );
  }

  Widget _build3dTab() {
    return ModelViewer(
      backgroundColor: const Color(0xff1a1412),
      src: widget.artifact.modelUrl,
      alt: "3D model",
      ar: true,
      autoRotate: true,
      cameraControls: true,
      onWebViewCreated: (controller) => context.read<AchievementProvider>().updateProgress(context, '3d_master'),
    );
  }

  Widget _buildCommentsTab() {
    return CommentsSection(
      artifactId: widget.artifact.id,
      commentService: _commentService,
      controller: ScrollController(),
    );
  }

  // --- Логика ---

  Future<void> _addComment() async {
    final user = context.read<AuthProviders>().user;
    if (user == null) {
      FlashMessage.info(context, S.of(context).loginToComment);
      return;
    }
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    await _commentService.addComment(widget.artifact.id, user.email ?? 'Unknown', text);
    context.read<AchievementProvider>().updateProgress(context, 'critic');
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        title: Text(S.of(context).deleteArtifact, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ArtifactProvider>().deleteArtifact(widget.artifact.id);
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.of(context).deleteAction),
          ),
        ],
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
