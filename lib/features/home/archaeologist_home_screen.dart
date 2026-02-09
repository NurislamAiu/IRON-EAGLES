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
          // 🌌 Новый фон с градиентом
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

  Widget _buildBottomNavBar(List<_NavItemData> items) {
    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              return _navItem(item.icon, i, item.label);
            }),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : Colors.white70,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.white60,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
              child: Text(label),
            )
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
