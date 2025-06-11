import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/category.dart';

void main() {
  group('Category Model Tests', () {
    test('отримання локалізованих категорій витрат', () {
      final categories = Categories.expense;
      expect(categories.isNotEmpty, true);
      expect(categories.any((c) => c.nameKey == 'food'), true);
      expect(categories.any((c) => c.nameKey == 'transport'), true);
    });

    test('отримання локалізованих категорій доходів', () {
      final categories = Categories.income;
      expect(categories.isNotEmpty, true);
      expect(categories.any((c) => c.nameKey == 'salary'), true);
    });

    test('валідація унікальності nameKey', () {
      final allCategories = [...Categories.expense, ...Categories.income];
      final nameKeys = allCategories.map((c) => c.nameKey).toList();
      final uniqueKeys = nameKeys.toSet();
      
      expect(nameKeys.length, uniqueKeys.length, 
             reason: 'Всі nameKey мають бути унікальними');
    });
  });
}