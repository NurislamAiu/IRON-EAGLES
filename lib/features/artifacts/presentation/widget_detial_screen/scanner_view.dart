import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _scanCount = 0;
  final int _maxScans = 15;
  bool _isProcessing = false;
  double _processingProgress = 0.0;
  String _statusText = "Настройте фокус на объекте";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _captureScan() {
    if (_scanCount < _maxScans) {
      setState(() {
        _scanCount++;
        _statusText = "Захвачено точек: ${_scanCount * 1240}";
      });
      if (_scanCount == _maxScans) {
        _startProcessing();
      }
    }
  }

  void _startProcessing() {
    setState(() {
      _isProcessing = true;
      _statusText = "Генерация 3D модели...";
    });

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_processingProgress >= 1.0) {
        timer.cancel();
        Navigator.pop(context, "assets/3d/museum_3d_0.glb"); // Return mock model path
      } else {
        setState(() {
          _processingProgress += 0.01;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Preview
          CameraPreview(_controller!),

          // 2. HUD Overlay (Grid)
          _buildHUDOverlay(),

          // 3. Technical UI
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                if (!_isProcessing) _buildScannerControls(),
                if (_isProcessing) _buildProcessingOverlay(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDOverlay() {
    return IgnorePointer(
      child: Stack(
        children: [
          // Scanning Circle
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Crosshair
          Center(
            child: Icon(Icons.add, color: Colors.cyanAccent.withOpacity(0.5), size: 40),
          ),
          // Grid lines
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            children: [
              const Text("ARCHAEOLOGY SCAN V2.4", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              Text(_statusText, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const Icon(Icons.sensors, color: Colors.redAccent, size: 24),
        ],
      ),
    );
  }

  Widget _buildScannerControls() {
    double progress = _scanCount / _maxScans;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                color: Colors.cyanAccent,
                backgroundColor: Colors.white10,
              ),
            ),
            GestureDetector(
              onTap: _captureScan,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.camera_outlined, size: 40, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Обойдите объект, делая снимки", style: TextStyle(color: Colors.white54)),
      ],
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(color: Colors.cyanAccent),
          const SizedBox(height: 20),
          Text("${(_processingProgress * 100).toInt()}%", style: const TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("ГЕНЕРАЦИЯ ПОЛИГОНОВ", style: TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.1)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
