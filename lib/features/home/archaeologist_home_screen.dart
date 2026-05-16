import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ArcheoAI/core/services/sound_service.dart';
import 'package:ArcheoAI/features/home/tabs/expedition_tab.dart';
import 'package:ArcheoAI/features/home/tabs/moderator_tab.dart';
import 'package:provider/provider.dart';

import '../auth/provider/auth_provider.dart';

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
    final bool isAuthenticated = email != null;

    /// ====== ФОРМИРУЕМ СПИСКИ ЭКРАНОВ ПО РОЛИ ======

    List<Widget> screens;
    List<_NavItemData> items;

    if (!isAuthenticated) {
      // ----------- ГОСТЬ -----------
      screens = const [
        HomeTab(),
        CommunitiesTab(),
        ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_filled, "Главная"),
        _NavItemData(Icons.groups, "Клубы"),
        _NavItemData(Icons.person, "Профиль"),
      ];
    } else if (isAdmin) {
      // ----------- АДМИН -----------
      screens = [
        const HomeTab(),
        const CommunitiesTab(),
        const ModeratorTab(),
        const ExpeditionTab(),
        const ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_filled, "Главная"),
        _NavItemData(Icons.groups, "Клубы"),
        _NavItemData(Icons.admin_panel_settings, "Админ"),
        _NavItemData(Icons.explore, "Проекты"),
        _NavItemData(Icons.person, "Профиль"),
      ];
    } else {
      // ----------- ОБЫЧНЫЙ ПОЛЬЗОВАТЕЛЬ -----------
      screens = [
        const HomeTab(),
        const CommunitiesTab(),
        const AddArtifactTab(),
        const ExpeditionTab(),
        const ProfileTab(),
      ];

      items = [
        _NavItemData(Icons.home_filled, "Главная"),
        _NavItemData(Icons.groups, "Клубы"),
        _NavItemData(Icons.add_circle, "Создать"),
        _NavItemData(Icons.explore, "Проекты"),
        _NavItemData(Icons.person, "Профиль"),
      ];
    }

    // 🔥 FIX: Ensure index is within bounds if role changes (e.g. logout)
    if (_index >= screens.length) {
      _index = screens.length - 1;
    }

    return Scaffold(
      extendBody: true,
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
