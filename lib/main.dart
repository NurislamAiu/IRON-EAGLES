import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:museumcode/router/app_router.dart';
import 'firebase_options.dart';

// 🔹 Импортируем провайдеры
import 'features/auth/provider/auth_provider.dart';
import 'features/artifacts/provider/artifact_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("INIT USER: ${FirebaseAuth.instance.currentUser?.email}");

  runApp(const MuseumApp());
}


class MuseumApp extends StatelessWidget {
  const MuseumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🧍 Авторизация
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        // 🏺 Артефакты
        ChangeNotifierProvider(create: (_) => ArtifactProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'MuseumCode',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4F3A)),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
