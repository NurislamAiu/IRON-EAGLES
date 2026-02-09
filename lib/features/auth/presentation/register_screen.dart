import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../provider/auth_provider.dart';
import 'login_screen.dart'; // For RotatingLoader

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
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
        FlashMessage.success(context, 'Аккаунт успешно создан!');
        await Future.delayed(const Duration(milliseconds: 300));
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
        default:
          message = 'Неизвестная ошибка: ${e.code}';
      }
      if (mounted) FlashMessage.error(context, message);
    } catch (e) {
      if (mounted) FlashMessage.error(context, 'Ошибка регистрации: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Новый фон с градиентом
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Кнопка "Назад"
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.8)),
            ),
          ),

          // Анимированная форма регистрации
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildGlassContainer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Регистрация',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                        _buildRegisterButton(),
                        const SizedBox(height: 12),
                        _buildLoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Оверлей загрузки
          if (_loading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Зарегистрироваться',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: const Text(
        'У меня уже есть аккаунт',
        style: TextStyle(
          color: Colors.white70,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: const Center(child: RotatingLoader()),
        ),
      ),
    );
  }
}
