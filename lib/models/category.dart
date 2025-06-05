import 'package:finance_app/l10n/app_localizations.dart';

class Category {
  final String nameKey; 
  final String icon;
  final int color;

  const Category({
    required this.nameKey,
    required this.icon,
    required this.color,
  });
  
  String getLocalizedName(AppLocalizations l10n) {
    switch (nameKey) {
      case 'food':
        return l10n.food;
      case 'transport':
        return l10n.transport;
      case 'entertainment':
        return l10n.entertainment;
      case 'utilities':
        return l10n.utilities;
      case 'shopping':
        return l10n.shopping;
      case 'health':
        return l10n.health;
      case 'education':
        return l10n.education;
      case 'salary':
        return l10n.salary;
      case 'bonus':
        return l10n.bonus;
      case 'investment':
        return l10n.investment;
      case 'other':
      default:
        return l10n.other;
    }
  }
}

class Categories {
  static const List<Category> expense = [
    Category(nameKey: 'food', icon: 'fastfood', color: 0xFFFF5722),
    Category(nameKey: 'transport', icon: 'directions_car', color: 0xFF2196F3),
    Category(nameKey: 'entertainment', icon: 'movie', color: 0xFF9C27B0),
    Category(nameKey: 'utilities', icon: 'home', color: 0xFF4CAF50),
    Category(nameKey: 'shopping', icon: 'shopping_bag', color: 0xFFFF9800),
    Category(nameKey: 'health', icon: 'local_hospital', color: 0xFFF44336),
    Category(nameKey: 'education', icon: 'school', color: 0xFF607D8B),
    Category(nameKey: 'other', icon: 'category', color: 0xFF795548),
  ];

  static const List<Category> income = [
    Category(nameKey: 'salary', icon: 'work', color: 0xFF4CAF50),
    Category(nameKey: 'bonus', icon: 'card_giftcard', color: 0xFF2196F3),
    Category(nameKey: 'investment', icon: 'trending_up', color: 0xFF9C27B0),
    Category(nameKey: 'other', icon: 'attach_money', color: 0xFF607D8B),
  ];
  
  static List<String> getLocalizedExpenseCategories(AppLocalizations l10n) {
    return expense.map((category) => category.getLocalizedName(l10n)).toList();
  }
  
  static List<String> getLocalizedIncomeCategories(AppLocalizations l10n) {
    return income.map((category) => category.getLocalizedName(l10n)).toList();
  }
  
  static String getLocalizedCategoryName(String nameKey, AppLocalizations l10n) {
    switch (nameKey) {
      case 'food':
        return l10n.food;
      case 'transport':
        return l10n.transport;
      case 'entertainment':
        return l10n.entertainment;
      case 'utilities':
        return l10n.utilities;
      case 'shopping':
        return l10n.shopping;
      case 'health':
        return l10n.health;
      case 'education':
        return l10n.education;
      case 'salary':
        return l10n.salary;
      case 'bonus':
        return l10n.bonus;
      case 'investment':
        return l10n.investment;
      case 'other':
      default:
        return l10n.other;
    }
  }
}