import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../artifacts/provider/achievement_provider.dart';

class ScanQRTab extends StatefulWidget {
  const ScanQRTab({super.key});

  @override
  State<ScanQRTab> createState() => _ScanQRTabState();
}

class _ScanQRTabState extends State<ScanQRTab> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
          ),
          onDetect: (capture) {
            if (_scanned) return;
            _scanned = true;

            final code = capture.barcodes.first.rawValue;

            // Trigger Achievement
            if (mounted) {
              context.read<AchievementProvider>().updateProgress(context, 'first_scan');
              context.read<AchievementProvider>().updateProgress(context, 'scholar');
            }

            Navigator.pushNamed(
              context,
              "/artifact/$code",
              arguments: code,
            );
          },
        ),

        // затемнение
        _overlay(),

        // рамка
        _scannerFrame(),

        // текст
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            "Наведите камеру на QR-код",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _overlay() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.55),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scannerFrame() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
      ),
    );
  }
}
