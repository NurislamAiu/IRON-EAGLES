import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class ArtifactLocationMap extends StatefulWidget {
  final String location;

  const ArtifactLocationMap({super.key, required this.location});

  @override
  State<ArtifactLocationMap> createState() => _ArtifactLocationMapState();
}

class _ArtifactLocationMapState extends State<ArtifactLocationMap> with SingleTickerProviderStateMixin {
  Future<LatLng?>? _coordinatesFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _coordinatesFuture = _getCoordinates();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<LatLng?> _getCoordinates() async {
    try {
      final locations = await locationFromAddress(widget.location);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      // Handle exceptions from geocoding (e.g., network issues, invalid address)
      print("Geocoding error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: _coordinatesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildErrorState();
        }

        final coordinates = snapshot.data!;
        return _buildMap(coordinates);
      },
    );
  }

  Widget _buildMap(LatLng coordinates) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: coordinates,
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.museumcode.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: coordinates,
                child: _buildAnimatedMarker(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker() {
    return FadeTransition(
      opacity: _animationController.drive(CurveTween(curve: Curves.easeInOut)),
      child: ScaleTransition(
        scale: _animationController.drive(Tween(begin: 0.7, end: 1.0)),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(0.4),
          ),
          child: const Center(
            child: Icon(
              Icons.location_pin,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, color: Colors.white38, size: 60),
            const SizedBox(height: 16),
            Text(
              "Не удалось определить местоположение",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
