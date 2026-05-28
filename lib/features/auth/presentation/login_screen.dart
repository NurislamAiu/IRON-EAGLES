import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../provider/auth_provider.dart';
import '../../../core/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final String? email;
  final String? password;

  const LoginScreen({super.key, this.email, this.password});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _email.text = widget.email ?? '';
    _password.text = widget.password ?? '';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
      FlashMessage.error(context, S.of(context).enterEmailPass);
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<AuthProviders>().login(email, password);
      if (mounted) {
        FlashMessage.success(context, S.of(context).welcomeBack);
        await Future.delayed(const Duration(milliseconds: 300));
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = S.of(context).invalidEmail;
          break;
        case 'user-not-found':
        case 'wrong-password':
          message = S.of(context).userNotFound;
          break;
        case 'user-disabled':
          message = S.of(context).userDisabled;
          break;
        case 'too-many-requests':
          message = S.of(context).tooManyRequests;
          break;
        default:
          message = S.of(context).errorOccurred;
      }
      if(mounted) FlashMessage.error(context, message);
    } catch (e) {
      if(mounted) FlashMessage.error(context, '${S.of(context).loginError}: ${e.toString()}');
    } finally {
      if(mounted) setState(() => _loading = false);
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
          
          // Анимированная форма входа
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildGlassContainer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).loginTitle,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GlassTextField(
                          controller: _email,
                          hint: S.of(context).email,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _password,
                          hint: S.of(context).password,
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 30),
                        _buildLoginButton(),
                        const SizedBox(height: 12),
                        _buildLegalAgreement(),
                        const SizedBox(height: 12),
                        _buildRegisterButton(),
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

  Widget _buildLegalAgreement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            S.of(context).agreementTerms,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legalLink(
                S.of(context).userAgreement,
                S.of(context).userAgreementContent,
              ),
              Text(
                " & ",
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
              _legalLink(
                S.of(context).privacyPolicy,
                S.of(context).privacyPolicyContent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legalLink(String title, String content) {
    return InkWell(
      onTap: () => context.push(
        Uri(
          path: '/legal',
          queryParameters: {
            'title': title,
            'content': content,
          },
        ).toString(),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
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

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          S.of(context).login,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () => context.push('/register'),
      child: Text(
        S.of(context).createAccount,
        style: const TextStyle(
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

class RotatingLoader extends StatefulWidget {
  const RotatingLoader({super.key});

  @override
  State<RotatingLoader> createState() => _RotatingLoaderState();
}

class _RotatingLoaderState extends State<RotatingLoader> with SingleTickerProviderStateMixin {
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
