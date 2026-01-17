import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlashMessage {
  /// Универсальный метод
  static void show(
      BuildContext context, {
        required String message,
        String? title,
        IconData? icon,
        Color backgroundColor = Colors.black87,
        FlushbarPosition position = FlushbarPosition.TOP,
        Duration duration = const Duration(seconds: 3),
      }) {
    Flushbar(
      title: title,
      message: message,
      icon: icon != null
          ? Icon(icon, size: 28.0, color: Colors.white)
          : null,
      duration: duration,
      backgroundColor: backgroundColor,
      flushbarPosition: position,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      animationDuration: const Duration(milliseconds: 400),
      barBlur: 10,
      isDismissible: true,
    ).show(context);
  }

  /// Успешное уведомление
  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      title: "Успешно ✅",
      icon: Icons.check_circle,
      backgroundColor: Colors.green.shade600,
    );
  }

  /// Ошибка
  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      title: "Ошибка ❌",
      icon: Icons.error_outline,
      backgroundColor: Colors.red.shade700,
    );
  }

  /// Информационное сообщение
  static void info(BuildContext context, String message) {
    show(
      context,
      message: message,
      title: "Инфо ℹ️",
      icon: Icons.info_outline,
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
