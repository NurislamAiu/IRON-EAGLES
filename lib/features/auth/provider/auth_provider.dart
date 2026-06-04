import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_service.dart';

class AuthProviders extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _role; // archaeologist / admin

  User? get user => _user;
  String? get role => _role;

  bool get isLoggedIn => _user != null;

  /// 🔥 Инициализация: слушаем Firebase + загружаем сохранённую роль
  AuthProviders() {
    _init();
  }

  Future<void> _init() async {
    // Загружаем роль из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('role') ?? 'archaeologist';

    // Firebase слушатель
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });

    notifyListeners();
  }

  /// 🎭 Установить роль (archaeologist)
  Future<void> setRole(String role) async {
    _role = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);

    notifyListeners();
  }

  /// 🔐 Логин
  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);

    // SPECIAL: если это admin – автоматически роль admin
    if (email == 'admin@gmail.com') {
      await setRole('admin');
    }

    notifyListeners();
  }

  /// 📝 Регистрация
  Future<void> register(String email, String password) async {
    _user = await _authService.register(email, password);

    // Если регистрируется обычный археолог
    if (_role == null) {
      await setRole('archaeologist');
    }

    notifyListeners();
  }

  /// 🚪 Выход из аккаунта
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');

    notifyListeners();
  }

  /// 🗑️ Delete account
  Future<void> deleteAccount() async {
    await _authService.deleteUserAccount();
    _user = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');

    notifyListeners();
  }
}
