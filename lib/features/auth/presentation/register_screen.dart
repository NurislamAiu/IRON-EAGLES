import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../provider/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _email.text.trim();
    final password = _password.text.trim();
    final confirm = _confirm.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      FlashMessage.error(context, 'Пожалуйста, заполните все поля');
      return;
    }

    if (password != confirm) {
      FlashMessage.error(context, 'Пароли не совпадают');
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<AuthProviders>().register(email, password);
      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Такой email уже зарегистрирован.';
          break;
        case 'invalid-email':
          message = 'Неверный формат email.';
          break;
        case 'weak-password':
          message = 'Пароль слишком слабый. Используйте минимум 6 символов.';
          break;
        case 'operation-not-allowed':
          message = 'Регистрация с этим методом отключена.';
          break;
        case 'network-request-failed':
          message = 'Нет соединения с интернетом.';
          break;
        default:
          message = 'Неизвестная ошибка: ${e.code}';
      }

      FlashMessage.error(context, message);
    } catch (e) {
      FlashMessage.error(context, 'Ошибка регистрации: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/museum_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.25), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Регистрация археолога',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 2),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              GlassTextField(
                                controller: _email,
                                hint: 'Email',
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 16),

                              GlassTextField(
                                controller: _password,
                                hint: 'Пароль',
                                icon: Icons.lock_outline,
                                obscure: true,
                              ),
                              const SizedBox(height: 16),

                              GlassTextField(
                                controller: _confirm,
                                hint: 'Подтвердите пароль',
                                icon: Icons.lock_person_outlined,
                                obscure: true,
                              ),
                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 6,
                                  ),
                                  child: const Text(
                                    'Зарегистрироваться',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: const Text(
                                  'У меня уже есть аккаунт',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔥 ПРОЗРАЧНЫЙ OVERLAY
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.45),
              child: const Center(child: RotatingLoader()),
            ),
        ],
      ),
    );
  }

}
