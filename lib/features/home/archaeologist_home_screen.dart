import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:museumcode/features/home/tabs/moderator_tab.dart';
import 'package:museumcode/features/home/tabs/scan_qr_tab.dart';
import 'package:provider/provider.dart';

import '../auth/provider/auth_provider.dart';

// Tabs
import 'tabs/home_tab.dart';
import 'tabs/add_artifact_tab.dart';
import 'tabs/my_artifacts_tab.dart';
import 'tabs/profile_tab.dart';

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
    final bool isAuthenticated = email != null;

    /// ====== ФОРМИРУЕМ СПИСКИ ЭКРАНОВ ПО РОЛИ ======

    List<Widget> screens;
    List<_NavItemData> items;

    if (!isAuthenticated) {
      // ----------- ГОСТЬ -----------
      screens = const [
        HomeTab(),
        ScanQRTab(),
        ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_outlined, "Главная"),
        _NavItemData(Icons.qr_code_scanner, "Сканировать"),
        _NavItemData(Icons.person_outline, "Профиль"),
      ];
    } else if (isAdmin) {
      // ----------- АДМИН -----------
      screens = const [
        HomeTab(),
        ModeratorTab(),
        ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_outlined, "Главная"),
        _NavItemData(Icons.admin_panel_settings, "Модерация"),
        _NavItemData(Icons.person_outline, "Профиль"),
      ];
    } else {
      // ----------- ОБЫЧНЫЙ ПОЛЬЗОВАТЕЛЬ -----------
      screens = const [
        HomeTab(),
        AddArtifactTab(),
        MyArtifactsTab(),
        ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_outlined, "Главная"),
        _NavItemData(Icons.add_circle_outline, "Добавить"),
        _NavItemData(Icons.inventory_2_outlined, "Мои"),
        _NavItemData(Icons.person_outline, "Профиль"),
      ];
    }

    return Scaffold(
      extendBody: true,

      body: Stack(
        children: [
          // 🌌 Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/museum_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(child: screens[_index]),
        ],
      ),

      // 🧭 Bottom Navigation — dynamic by ROLE
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.10),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  return _navItem(item.icon, i, item.label);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    final bool selected = _index == index;

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.brown.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: selected ? 28 : 24,
              color: selected ? Colors.brown.shade300 : Colors.white70,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.brown.shade200 : Colors.white60,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class for tab items
class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData(this.icon, this.label);
}
