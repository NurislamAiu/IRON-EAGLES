import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/artifact_provider.dart';
import '../domain/artifact_model.dart';
import '../../../core/localization/app_localizations.dart';

class ArtifactListScreen extends StatefulWidget {
  const ArtifactListScreen({super.key});

  @override
  State<ArtifactListScreen> createState() => _ArtifactListScreenState();
}

class _ArtifactListScreenState extends State<ArtifactListScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ArtifactProvider>().fetchArtifacts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final list = provider.artifacts;
    final locale = S.of(context).locale;
    final filtered = _search.text.isEmpty
        ? list
        : list
        .where((a) {
          final title = a.getDisplayTitle(locale).toLowerCase();
          final query = _search.text.toLowerCase();
          return title.contains(query);
        })
        .toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/museum_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    S.of(context).museumArtifacts,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchField(),
                  const SizedBox(height: 12),

                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filtered.isEmpty
                        ? Center(
                      child: Text(
                        S.of(context).noArtifacts,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final artifact = filtered[i];
                        return GestureDetector(
                          onTap: () => context.push(
                            '/artifact/${artifact.id}',
                            extra: artifact,
                          ),
                          child: _artifactCard(artifact),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.white10,
      width: 110,
      height: 110,
      child: const Icon(Icons.museum_outlined, color: Colors.white24, size: 40),
    );
  }

  Widget _artifactCard(Artifact artifact) {
    final locale = S.of(context).locale;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.horizontal(left: Radius.circular(14)),
            child: artifact.imageUrl.isEmpty 
                ? _buildErrorImage()
                : (artifact.imageUrl.startsWith('http')
                    ? Image.network(
                        artifact.imageUrl,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildErrorImage(),
                      )
                    : Image.asset(
                        artifact.imageUrl,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildErrorImage(),
                      )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artifact.getDisplayTitle(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    artifact.getDisplayLocation(locale),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${S.of(context).addedBy}: ${artifact.addedBy}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _search,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: S.of(context).searchByTitle,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
      ),
    );
  }
}
