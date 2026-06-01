import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ArcheoAI/features/artifacts/provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:ArcheoAI/router/app_router.dart';
import 'firebase_options.dart';

import 'package:ArcheoAI/features/auth/provider/auth_provider.dart';
import 'package:ArcheoAI/features/auth/provider/safety_provider.dart';
import 'package:ArcheoAI/features/artifacts/provider/artifact_provider.dart';
import 'package:ArcheoAI/features/artifacts/provider/achievement_provider.dart';
import 'package:ArcheoAI/features/artifacts/provider/expedition_provider.dart';
import 'package:ArcheoAI/features/blogs/provider/blog_provider.dart';
import 'package:ArcheoAI/features/communities/provider/community_provider.dart';
import 'package:ArcheoAI/core/providers/language_provider.dart';
import 'package:ArcheoAI/core/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('ru', null);
  runApp(const MuseumApp());
}

class MuseumApp extends StatefulWidget {
  const MuseumApp({super.key});

  @override
  State<MuseumApp> createState() => _MuseumAppState();
}

class _MuseumAppState extends State<MuseumApp> {
  late final AuthProviders _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProviders();
    _router = AppRouter.createRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (_) => UserSafetyProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ExpeditionProvider()),
        ChangeNotifierProvider(create: (_) => ArtifactProvider()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'ArcheoAI',
            locale: langProvider.locale,
            localizationsDelegates: const [
              SDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ru')],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4F3A)),
              useMaterial3: true,
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
