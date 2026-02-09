import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  (startLat + endLat) / 2,
                  (startLng + endLng) / 2,
                ),
                initialZoom: 3.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [LatLng(startLat, startLng), LatLng(endLat, endLng)],
                      color: Colors.orangeAccent,
                      strokeWidth: 4.0,
                      pattern: StrokePattern.dashed(segments: [10, 5]),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(startLat, startLng),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.auto_awesome, color: Colors.greenAccent, size: 30),
                    ),
                    Marker(
                      point: LatLng(endLat, endLng),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.redAccent, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildJourneyInfo(),
      ],
    );
  }

  Widget _buildJourneyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLocationInfo(Icons.auto_awesome, "Происхождение", startName, Colors.greenAccent),
          const Icon(Icons.arrow_forward, color: Colors.white38),
          _buildLocationInfo(Icons.location_on, "Найдено", endName, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(IconData icon, String label, String name, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
