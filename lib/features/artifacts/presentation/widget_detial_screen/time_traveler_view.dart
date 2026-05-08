import 'package:flutter/material.dart';

class TimeTravelerView extends StatefulWidget {
  final String ancientUrl;
  final String modernUrl;

  const TimeTravelerView({
    super.key, 
    required this.ancientUrl, 
    required this.modernUrl
  });

  @override
  State<TimeTravelerView> createState() => _TimeTravelerViewState();
}

class _TimeTravelerViewState extends State<TimeTravelerView> {
  double _timeProgress = 0.5; // Start in the middle for a cool effect

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Путешествие во времени",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // The Stack overlays the two images
        Stack(
          alignment: Alignment.center,
          children: [
            // Bottom Layer: Ancient Image
            _buildImage(widget.ancientUrl),
            
            // Top Layer: Modern Image (its opacity changes!)
            Opacity(
              opacity: _timeProgress,
              child: _buildImage(widget.modernUrl),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // The Slider "travels" through time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.history, color: Colors.white54, size: 20),
              Expanded(
                child: Slider(
                  value: _timeProgress,
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Colors.white12,
                  onChanged: (val) => setState(() => _timeProgress = val),
                ),
              ),
              const Icon(Icons.today, color: Colors.white54, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text("Прошлое", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
             Text("Сегодня", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: url.startsWith('http')
          ? Image.network(
              url,
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorState(),
            )
          : Image.asset(
              url.isEmpty ? 'assets/images/museum_bg.jpg' : url,
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorState(),
            ),
    );
  }

  Widget _buildErrorState() {
     return Container(
       height: 350,
       width: double.infinity,
       color: Colors.white10,
       child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white24, size: 50)),
     );
  }
}
