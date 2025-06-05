import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  ThemeMode _themeMode = ThemeMode.system;
  
  Locale _locale = const Locale('uk');
  
  String _currency = 'UAH';

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get currency => _currency;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    final languageCode = prefs.getString('language_code') ?? 'uk';
    _locale = Locale(languageCode);
    
    _currency = prefs.getString('currency') ?? 'UAH';
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.system);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    notifyListeners();
  }

  String getCurrencySymbol() {
    switch (_currency) {
      case 'UAH':
        return '₴';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return '₴';
    }
  }

  String getCurrencyName() {
    switch (_currency) {
      case 'UAH':
        return _locale.languageCode == 'uk' 
            ? 'Українська гривня' 
            : 'Ukrainian Hryvnia';
      case 'USD':
        return _locale.languageCode == 'uk' 
            ? 'Долар США' 
            : 'US Dollar';
      case 'EUR':
        return _locale.languageCode == 'uk' 
            ? 'Євро' 
            : 'Euro';
      default:
        return _locale.languageCode == 'uk' 
            ? 'Українська гривня' 
            : 'Ukrainian Hryvnia';
    }
  }

  String formatAmount(double amount) {
    final symbol = getCurrencySymbol();
    return '${amount.toStringAsFixed(2)} $symbol';
  }

  String formatAmountShort(double amount) {
    final symbol = getCurrencySymbol();
    return '${amount.toStringAsFixed(0)} $symbol';
  }

  bool isDark(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}