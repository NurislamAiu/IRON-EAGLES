import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FullMapScreen extends StatelessWidget {
  final LatLng? center;
  final double initialZoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final String title;

  const FullMapScreen({
    super.key,
    this.center,
    this.initialZoom = 13.0,
    this.markers = const [],
    this.polylines = const [],
    this.title = 'Карта',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1412),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center ?? const LatLng(48.0196, 66.9237), // Центр Казахстана
          initialZoom: initialZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.archeoai.app',
          ),
          if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
          if (markers.isNotEmpty) MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
