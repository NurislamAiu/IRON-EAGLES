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

import 'package:ArcheoAI/features/auth/provider/auth_provider.dart';
import '../../core/localization/app_localizations.dart';

// Tabs
import 'tabs/home_tab.dart';
import 'tabs/add_artifact_tab.dart';
import 'tabs/profile_tab.dart';
import '../communities/presentation/communities_tab.dart';

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

    /// ====== РОЛИ ======
    final bool isAdmin = email == "admin@gmail.com";

    /// ====== ФОРМИРУЕМ СПИСКИ ЭКРАНОВ ПО РОЛИ ======

    List<Widget> screens;
    List<_NavItemData> items;

    if (isAdmin) {
      // ----------- АДМИН -----------
      screens = [
        const HomeTab(),
        const CommunitiesTab(),
        const ModeratorTab(),
        const ExpeditionTab(),
        const ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_filled, S.of(context).home),
        _NavItemData(Icons.groups, S.of(context).clubs),
        _NavItemData(Icons.admin_panel_settings, S.of(context).admin),
        _NavItemData(Icons.explore, S.of(context).projects),
        _NavItemData(Icons.person, S.of(context).profile),
      ];
    } else {
      // ----------- ОБЫЧНЫЙ ПОЛЬЗОВАТЕЛЬ (АРХЕОЛОГ) -----------
      screens = [
        const HomeTab(),
        const CommunitiesTab(),
        const AddArtifactTab(),
        const ExpeditionTab(),
        const ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_filled, S.of(context).home),
        _NavItemData(Icons.groups, S.of(context).clubs),
        _NavItemData(Icons.add_circle, S.of(context).create),
        _NavItemData(Icons.explore, S.of(context).projects),
        _NavItemData(Icons.person, S.of(context).profile),
      ];
    }

    // 🔥 FIX: Ensure index is within bounds if role changes (e.g. logout)
    if (_index >= screens.length) {
      _index = screens.length - 1;
    }

    return Scaffold(
      extendBody: true,
      floatingActionButton: _index == 0 ? FloatingActionButton(
        onPressed: _scanArtifactQr,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
      ) : null,
      body: Stack(
        children: [
          // 🌌 Фон с градиентом
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a), Color(0xff2c1e19)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Контент экрана
          SafeArea(child: screens[_index]),
        ],
      ),

      // 🧭 Bottom Navigation
      bottomNavigationBar: _buildBottomNavBar(items),
    );
  }

  Future<void> _scanArtifactQr() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (scannedValue == null || scannedValue.isEmpty) return;
    if (!mounted) return;

    final value = scannedValue.trim();
    final artifactProvider = context.read<ArtifactProvider>();
    final artifacts = artifactProvider.artifacts;

    // 1. Проверка на URL (ESP32 или Deep Link)
    if (value.startsWith('http://') || value.startsWith('https://')) {
      try {
        final uri = Uri.parse(value);
        final baseUrl = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
        final pathSegments = uri.pathSegments;

        if (pathSegments.isEmpty) {
          // Это просто ESP32 URL без артефакта, например http://172.18.100.4
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Esp32MonitorScreen(initialUrl: baseUrl),
            ),
          );
          return;
        }

        final artifactSlug = pathSegments.first;
        Artifact? foundArtifact;

        // Поиск по slug
        for (final artifact in artifacts) {
          if (artifact.slug == artifactSlug) {
            foundArtifact = artifact;
            break;
          }
        }

        // Fallback: если slug не найден, попробовать искать по id
        if (foundArtifact == null) {
          for (final artifact in artifacts) {
            if (artifact.id == artifactSlug) {
              foundArtifact = artifact;
              break;
            }
          }
        }

        if (foundArtifact != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArtifactDetailScreen(
                artifact: foundArtifact!.copyWith(esp32Url: baseUrl),
              ),
            ),
          );
        } else {
          FlashMessage.error(context, "Артефакт не найден");
        }
        return;
      } catch (e) {
        debugPrint("QR Parse error: $e");
      }
    }

    // 2. Fallback для старых QR (только ID или slug)
    Artifact? foundArtifact;
    for (final artifact in artifacts) {
      if (artifact.id == value || artifact.slug == value) {
        foundArtifact = artifact;
        break;
      }
    }

    if (foundArtifact != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArtifactDetailScreen(artifact: foundArtifact!),
        ),
      );
    } else {
      FlashMessage.error(context, "Артефакт не найден");
    }
  }

  Widget _buildBottomNavBar(List<_NavItemData> items) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (i) {
              final item = items[i];
              return Expanded(child: _navItem(item.icon, i, item.label));
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Colors.orange.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 26,
              color: selected ? Colors.orangeAccent : Colors.white60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: selected ? Colors.orangeAccent : Colors.white38,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData(this.icon, this.label);
}
