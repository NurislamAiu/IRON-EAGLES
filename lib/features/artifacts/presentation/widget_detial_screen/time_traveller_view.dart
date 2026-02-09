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
  double _timeProgress = 0.0; // 0.0 = Ancient, 1.0 = Modern

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The Stack overlays the two images
        Stack(
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
        const SizedBox(height: 20),
        // The Slider "travels" through time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Прошлое", style: TextStyle(color: Colors.white70)),
            Expanded(
              child: Slider(
                value: _timeProgress,
                activeColor: Colors.orangeAccent,
                onChanged: (val) => setState(() => _timeProgress = val),
              ),
            ),
            const Text("Сегодня", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        url,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
