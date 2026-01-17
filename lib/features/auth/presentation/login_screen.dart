import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      FlashMessage.error(context, 'Введите email и пароль');
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<AuthProviders>().login(email, password);
      if (mounted) {
        FlashMessage.success(context, 'Добро пожаловать!');
        await Future.delayed(const Duration(milliseconds: 300));
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Неверный формат email.';
          break;
        case 'user-not-found':
          message = 'Пользователь с таким email не найден.';
          break;
        case 'wrong-password':
          message = 'Неверный пароль. Попробуйте ещё раз.';
          break;
        case 'user-disabled':
          message = 'Этот аккаунт был отключён.';
          break;
        case 'too-many-requests':
          message = 'Слишком много попыток входа. Попробуйте позже.';
          break;
        case 'network-request-failed':
          message = 'Нет соединения с интернетом.';
          break;
        default:
          message = 'Неверный логин или пароль. Попробуйте ещё раз.';
      }
      FlashMessage.error(context, message);
    } catch (e) {
      FlashMessage.error(context, 'Ошибка входа: ${e.toString()}');
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

          Positioned(
            top: 50,
            left: 30,
            child: IconButton(
              onPressed: () => context.push('/'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),

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
                            color: Colors.white.withOpacity(0.25),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Вход для археолога',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(1, 2),
                                    blurRadius: 4,
                                  ),
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
                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 6,
                                ),
                                child: Text(
                                  'Войти',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: () => context.push('/register'),
                              child: const Text(
                                'Создать аккаунт',
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

          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(child: RotatingLoader()),
            ),
        ],
      ),
    );
  }
}

class RotatingLoader extends StatefulWidget {
  const RotatingLoader({super.key});

  @override
  State<RotatingLoader> createState() => _RotatingLoaderState();
}

class _RotatingLoaderState extends State<RotatingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/images/sand-timer.png',
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }
}
