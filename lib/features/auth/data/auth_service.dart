import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    try {
      // Используем set с merge: true вместо update, чтобы не было ошибки, если документа нет
      await _firestore.collection('users').doc(result.user!.uid).set({
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Не удалось обновить lastLogin в Firestore: $e");
      // Мы не прерываем процесс авторизации, если Firestore запретил доступ (например, из-за правил безопасности)
    }

    return result.user;
  }

  Future<User?> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'role': 'archaeologist',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint("Не удалось сохранить пользователя в Firestore: $e");
      }
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
