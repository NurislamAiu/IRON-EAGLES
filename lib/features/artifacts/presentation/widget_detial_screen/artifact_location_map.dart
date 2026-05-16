import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../full_map_screen.dart';

class ArtifactLocationMap extends StatefulWidget {
  final String location;
  final double? latitude;
  final double? longitude;

  const ArtifactLocationMap({
    super.key, 
    required this.location,
    this.latitude,
    this.longitude,
  });

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
    if (widget.latitude != null && widget.longitude != null) {
      return LatLng(widget.latitude!, widget.longitude!);
    }

    try {
      if (widget.location.isEmpty) return null;
      final locations = await locationFromAddress(widget.location);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: _coordinatesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
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
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: coordinates,
                    initialZoom: 10.0,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none), // Disable interaction in preview
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.archeoai.app',
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
                            center: coordinates,
                            title: widget.location,
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: coordinates,
                                child: const Icon(Icons.location_on, color: Colors.orangeAccent, size: 40),
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.location,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ],
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
            color: Colors.orangeAccent.withOpacity(0.3),
          ),
          child: const Center(
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.orangeAccent,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: Colors.white.withOpacity(0.1), size: 64),
          const SizedBox(height: 16),
          Text(
            "Местоположение уточняется...",
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
