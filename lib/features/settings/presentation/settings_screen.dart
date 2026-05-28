import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/language_provider.dart';
import '../../auth/provider/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff2c1e19),
      appBar: AppBar(
        title: Text(S.of(context).settings, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                _buildSectionTitle(S.of(context).language),
                _glassCard(
                  child: Consumer<LanguageProvider>(
                    builder: (context, langProvider, child) {
                      return Column(
                        children: [
                          _langOption(context, langProvider, 'ru', S.of(context).russian),
                          const SizedBox(height: 12),
                          _langOption(context, langProvider, 'en', S.of(context).english),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(S.of(context).get('account')),
                _glassCard(
                  child: Column(
                    children: [
                      _settingsButton(
                        context,
                        icon: Icons.logout,
                        text: S.of(context).logout,
                        onTap: () {
                          context.read<AuthProviders>().logout();
                          context.go('/');
                        },
                        color: Colors.white10,
                      ),
                      const SizedBox(height: 12),
                      _settingsButton(
                        context,
                        icon: Icons.delete_forever,
                        text: S.of(context).deleteAccount,
                        onTap: () => _confirmDeleteAccount(context),
                        color: Colors.red.shade900.withOpacity(0.3),
                        textColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, LanguageProvider lp, String code, String label) {
    final selected = lp.locale.languageCode == code;
    return GestureDetector(
      onTap: () => lp.setLocale(Locale(code)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.orangeAccent.withOpacity(0.15) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Colors.orangeAccent.withOpacity(0.5) : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.orangeAccent : Colors.white70,
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: Colors.orangeAccent, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _settingsButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
    Color textColor = Colors.white70,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(color: textColor, fontSize: 16)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.3), size: 14),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2c1e19),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(S.of(context).deleteAccount, style: const TextStyle(color: Colors.white)),
        content: Text(
          S.of(context).deleteAccountConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel, style: const TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await context.read<AuthProviders>().deleteAccount();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).deleteAccountSuccess)),
                  );
                  context.go('/');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${S.of(context).deleteAccountError}: $e")),
                  );
                }
              }
            },
            child: Text(S.of(context).deleteAction, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
