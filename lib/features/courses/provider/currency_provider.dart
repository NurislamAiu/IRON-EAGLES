import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currency = 'USD';

  String get currency => _currency;

  final Map<String, double> _rates = {
    'USD': 1.0,
    'KZT': 450.0,
    'EUR': 0.92,
    'RUB': 92.0,
  };

  final Map<String, String> _symbols = {
    'USD': '\$',
    'KZT': '₸',
    'EUR': '€',
    'RUB': '₽',
  };

  List<String> get availableCurrencies => _rates.keys.toList();

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('selected_currency') ?? 'USD';
    notifyListeners();
  }

  Future<void> setCurrency(String newCurrency) async {
    if (_rates.containsKey(newCurrency)) {
      _currency = newCurrency;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_currency', newCurrency);
    }
  }

  String formatPrice(double priceInUsd) {
    if (priceInUsd <= 0) return "Бесплатно";
    double converted = priceInUsd * (_rates[_currency] ?? 1.0);
    String symbol = _symbols[_currency] ?? '\$';
    
    // Форматируем без лишних нулей
    if (converted == converted.toInt()) {
      return "$symbol${converted.toInt()}";
    }
    return "$symbol${converted.toStringAsFixed(2)}";
  }
}
