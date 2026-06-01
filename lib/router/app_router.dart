import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ArcheoAI/features/artifacts/domain/artifact_model.dart';
import 'package:ArcheoAI/features/artifacts/domain/expedition_model.dart';
import 'package:ArcheoAI/features/artifacts/presentation/achievements_screen.dart';
import 'package:ArcheoAI/features/artifacts/presentation/artifact_detail_screen.dart';
import 'package:ArcheoAI/features/artifacts/presentation/expedition_chat_screen.dart';
import 'package:ArcheoAI/features/artifacts/presentation/favorites_screen.dart';
import 'package:ArcheoAI/features/artifacts/presentation/artifact_list_screen.dart';
import 'package:ArcheoAI/features/auth/presentation/login_screen.dart';
import 'package:ArcheoAI/features/auth/presentation/register_screen.dart';
import 'package:ArcheoAI/features/auth/presentation/role_selection_screen.dart';
import 'package:ArcheoAI/features/auth/presentation/legal_screen.dart';
import 'package:ArcheoAI/features/auth/provider/auth_provider.dart';
import 'package:ArcheoAI/features/home/archaeologist_home_screen.dart';
import 'package:ArcheoAI/features/home/tabs/add_artifact_tab.dart';
import 'package:ArcheoAI/features/settings/presentation/settings_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProviders authProvider) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final auth = authProvider;
        final logged = auth.isLoggedIn;
        final role = auth.role;
        final goingTo = state.uri.toString();

        if (role == null && goingTo != '/') return '/';

        if (role == 'visitor') {
          final allowed = ['/', '/home', '/artifact', '/profile', '/legal', '/favorites', '/settings', '/achievements'];
          bool isAllowed = allowed.any((p) => goingTo.startsWith(p));
          return isAllowed ? null : '/home';
        }

        if (role == 'archaeologist') {
          if (!logged) {
            if (goingTo.startsWith('/login') || goingTo == '/register' || goingTo.startsWith('/legal') || goingTo == '/') {
              return null;
            }
            return '/login';
          }
          if (logged && (goingTo.startsWith('/login') || goingTo == '/register')) return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(path: '/', pageBuilder: (_, __) => _buildFadeTransition(const RoleSelectionScreen())),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            final email = state.uri.queryParameters['email'];
            final password = state.uri.queryParameters['password'];
            return _buildSlideUpTransition(LoginScreen(email: email, password: password));
          },
        ),
        GoRoute(path: '/register', pageBuilder: (_, __) => _buildFadeTransition(const RegisterScreen())),
        GoRoute(path: '/home', pageBuilder: (_, __) => _buildFadeTransition(const ArchaeologistHomeScreen())),
        GoRoute(path: '/add', pageBuilder: (_, __) => _buildSlideUpTransition(const AddArtifactTab())),
        GoRoute(path: '/artifacts', pageBuilder: (_, __) => _buildFadeTransition(const ArtifactListScreen())),
        GoRoute(
          path: '/artifact/:id',
          pageBuilder: (context, state) {
            final artifact = state.extra as Artifact;
            return _buildSlideUpTransition(ArtifactDetailScreen(artifact: artifact));
          },
        ),
        GoRoute(path: '/achievements', pageBuilder: (_, __) => _buildFadeTransition(const AchievementsScreen())),
        GoRoute(path: '/favorites', pageBuilder: (_, __) => _buildFadeTransition(const FavoritesScreen())),
        GoRoute(path: '/settings', pageBuilder: (_, __) => _buildFadeTransition(const SettingsScreen())),
        GoRoute(
          path: '/legal',
          pageBuilder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? "";
            final content = state.uri.queryParameters['content'] ?? "";
            return _buildFadeTransition(LegalScreen(title: title, content: content));
          },
        ),
        GoRoute(
          path: '/expedition-chat',
          pageBuilder: (context, state) {
            final exp = state.extra as Expedition;
            return _buildFadeTransition(ExpeditionChatScreen(expedition: exp));
          },
        ),
      ],
    );
  }

  static CustomTransitionPage _buildFadeTransition(Widget child) => CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  );

  static CustomTransitionPage _buildSlideUpTransition(Widget child) => CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, a, __, c) {
      final offset = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic));
      return FadeTransition(opacity: a, child: SlideTransition(position: offset, child: c));
    },
  );
}
