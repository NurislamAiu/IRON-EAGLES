import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_button.dart';
import '../../auth/provider/auth_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    final auth = context.read<AuthProviders>();

    // Сохраняем роль в провайдер + SharedPreferences
    await auth.setRole(role);

    if (role == 'archaeologist') {
      // Переход на логин
      context.go('/login');
    }
    else if (role == 'visitor') {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/museum_bg.jpg', fit: BoxFit.cover),

          Container(color: Colors.black.withOpacity(0.5)),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Кто вы?',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  GlassButton(
                    icon: Icons.search,
                    text: 'Я посетитель',
                    onTap: () => _selectRole(context, 'visitor'),
                  ),

                  const SizedBox(height: 20),

                  GlassButton(
                    icon: Icons.engineering,
                    text: 'Я археолог',
                    onTap: () => _selectRole(context, 'archaeologist'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
