import 'dart:ui';
import 'package:flutter/material.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({super.key});

  final List<Map<String, String>> terms = const [
    {'title': 'Kurgan', 'desc': 'A type of tumulus or burial mound, often found in Central Asia and Eastern Europe.'},
    {'title': 'Petroglyph', 'desc': 'Images created by removing part of a rock surface by incising, picking, or carving.'},
    {'title': 'Sakas', 'desc': 'A group of nomadic Indo-Iranian peoples who historically inhabited the northern and eastern Eurasian Steppe.'},
    {'title': 'Animal Style', 'desc': 'An approach to decoration found from China to Central Europe in the Iron Age, characterized by animal motifs.'},
    {'title': 'Dromos', 'desc': 'An entrance passage or avenue leading to a building or tomb.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0c0a),
      appBar: AppBar(
        title: const Text("Knowledge Base"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: terms.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(terms[i]['title']!, style: const TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(terms[i]['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
              ],
            ),
          );
        },
      ),
    );
  }
}
