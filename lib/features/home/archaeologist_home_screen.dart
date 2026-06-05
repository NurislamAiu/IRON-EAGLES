import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ArcheoAI/core/services/sound_service.dart';
import 'package:ArcheoAI/features/artifacts/presentation/artifact_detail_screen.dart';
import 'package:ArcheoAI/features/artifacts/domain/artifact_model.dart';
import 'package:ArcheoAI/features/artifacts/provider/artifact_provider.dart';
import 'package:ArcheoAI/features/esp32_monitor/presentation/esp32_monitor_screen.dart';
import 'package:ArcheoAI/core/widgets/flash_message.dart';
import 'package:ArcheoAI/features/home/tabs/expedition_tab.dart';
import 'package:ArcheoAI/features/home/tabs/moderator_tab.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:ArcheoAI/features/auth/provider/auth_provider.dart';
import '../../core/localization/app_localizations.dart';

// Tabs
import 'tabs/home_tab.dart';
import 'tabs/add_artifact_tab.dart';
import 'tabs/profile_tab.dart';
import '../communities/presentation/communities_tab.dart';
import '../artifacts/presentation/ai_archaeologist_screen.dart';

class ArchaeologistHomeScreen extends StatefulWidget {
  const ArchaeologistHomeScreen({super.key});

  @override
  State<ArchaeologistHomeScreen> createState() =>
      _ArchaeologistHomeScreenState();
}

class _ArchaeologistHomeScreenState extends State<ArchaeologistHomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProviders>().user;
    final email = user?.email;
    final bool isAdmin = email == "admin@gmail.com";
    final s = S.of(context);

    // Dynamic screens list: Home, Clubs, AI, Create/Admin, Projects, QR, Profile
    final List<Widget> screens = [
      const HomeTab(),
      const CommunitiesTab(),
      const AiArchaeologistScreen(isTab: true),
      isAdmin ? const ModeratorTab() : const AddArtifactTab(),
      const ExpeditionTab(),
      const QrScannerTab(),
      const ProfileTab(),
    ];

    final List<_NavItemData> items = [
      _NavItemData(Icons.home_filled, s.home),
      _NavItemData(Icons.groups, s.clubs),
      _NavItemData(Icons.auto_awesome, "AI"),
      _NavItemData(isAdmin ? Icons.admin_panel_settings : Icons.add_circle, isAdmin ? s.admin : s.create),
      _NavItemData(Icons.explore, s.projects),
      _NavItemData(Icons.qr_code_scanner, "QR"),
      _NavItemData(Icons.person, s.profile),
    ];

    if (_index >= screens.length) {
      _index = screens.length - 1;
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 🌌 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a), Color(0xff2c1e19)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Content
          SafeArea(child: screens[_index]),
        ],
      ),

      // 🧭 Bottom Navigation
      bottomNavigationBar: _buildBottomNavBar(items),
    );
  }

  Widget _buildBottomNavBar(List<_NavItemData> items) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (i) {
              return Expanded(child: _navItem(items[i].icon, i, items[i].label));
            }),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    final bool selected = _index == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SoundService.playClick();
        setState(() => _index = index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? Colors.orange.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 20,
              color: selected ? Colors.orangeAccent : Colors.white54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8,
              color: selected ? Colors.orangeAccent : Colors.white30,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}

class QrScannerTab extends StatefulWidget {
  const QrScannerTab({super.key});

  @override
  State<QrScannerTab> createState() => _QrScannerTabState();
}

class _QrScannerTabState extends State<QrScannerTab> {
  bool _isProcessing = false;

  void _handleScan(String value, BuildContext context) async {
    if (_isProcessing) return;
    _isProcessing = true;

    final val = value.trim();
    final artifactProvider = context.read<ArtifactProvider>();
    final artifacts = artifactProvider.artifacts;

    if (val.startsWith('http://') || val.startsWith('https://')) {
      try {
        final uri = Uri.parse(val);
        final baseUrl = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
        final pathSegments = uri.pathSegments;

        if (pathSegments.isEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Esp32MonitorScreen(initialUrl: baseUrl)));
        } else {
          final artifactSlug = pathSegments.first;
          final foundArtifact = artifacts.firstWhere(
            (a) => a.slug == artifactSlug || a.id == artifactSlug,
            orElse: () => throw 'NotFound',
          );
          Navigator.push(context, MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: foundArtifact.copyWith(esp32Url: baseUrl))));
        }
      } catch (e) {
        FlashMessage.error(context, "Артефакт не найден");
      }
    } else {
      try {
        final foundArtifact = artifacts.firstWhere((a) => a.id == val || a.slug == val);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ArtifactDetailScreen(artifact: foundArtifact)));
      } catch (e) {
        FlashMessage.error(context, "Артефакт не найден");
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                _handleScan(barcode.rawValue!, context);
                break;
              }
            }
          },
        ),
        // Overlay UI
        CustomPaint(
          size: Size.infinite,
          painter: QrScannerPainter(),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
              child: const Text("Scan Artifact QR Code", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData(this.icon, this.label);
}

class QrScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cutOutSize = 250.0;
    final rect = Rect.fromLTWH(
      (size.width - cutOutSize) / 2,
      (size.height - cutOutSize) / 2,
      cutOutSize,
      cutOutSize,
    );

    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Draw background with a hole
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20))),
      ),
      paint,
    );

    final borderPaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
