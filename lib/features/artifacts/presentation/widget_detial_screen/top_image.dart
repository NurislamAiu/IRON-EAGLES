import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  final String? url;

  const TopImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Container(
        height: 320,
        width: double.infinity,
        color: Colors.brown.shade700,
        child: (url != null && url!.isNotEmpty)
            ? Image.network(url!, fit: BoxFit.cover)
            : Center(
          child: Icon(Icons.museum_rounded,
              size: 100, color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }
}
