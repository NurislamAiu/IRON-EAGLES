import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../full_map_screen.dart';
import 'package:ArcheoAI/core/localization/app_localizations.dart';

class ArtifactJourneyMap extends StatelessWidget {
  final double startLat;
  final double startLng;
  final String startName;
  final double endLat;
  final double endLng;
  final String endName;

  const ArtifactJourneyMap({
    super.key,
    required this.startLat,
    required this.startLng,
    required this.startName,
    required this.endLat,
    required this.endLng,
    required this.endName,
  });

  @override
  Widget build(BuildContext context) {
    final center = LatLng((startLat + endLat) / 2, (startLng + endLng) / 2);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 4.0,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none), // Disable interaction in preview
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.archeoai.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [LatLng(startLat, startLng), LatLng(endLat, endLng)],
                          color: Colors.orangeAccent,
                          strokeWidth: 3.0,
                          pattern: StrokePattern.dashed(segments: const [10, 5]),
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(startLat, startLng),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 24),
                        ),
                        Marker(
                          point: LatLng(endLat, endLng),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on_rounded, color: Colors.orangeAccent, size: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Full Screen Trigger
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullMapScreen(
                            center: center,
                            title: S.of(context).artifactPath,
                            initialZoom: 4.0,
                            polylines: [
                              Polyline(
                                points: [LatLng(startLat, startLng), LatLng(endLat, endLng)],
                                color: Colors.orangeAccent,
                                strokeWidth: 4.0,
                                pattern: StrokePattern.dashed(segments: const [10, 5]),
                              ),
                            ],
                            markers: [
                              Marker(
                                point: LatLng(startLat, startLng),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 24),
                              ),
                              Marker(
                                point: LatLng(endLat, endLng),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on_rounded, color: Colors.orangeAccent, size: 30),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildJourneyInfo(context),
      ],
    );
  }

  Widget _buildJourneyInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildLocationInfo(Icons.auto_awesome, S.of(context).origin, startName, Colors.cyanAccent)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.2), size: 20),
          ),
          Expanded(child: _buildLocationInfo(Icons.location_on_rounded, S.of(context).find, endName, Colors.orangeAccent)),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(IconData icon, String label, String name, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name, 
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
