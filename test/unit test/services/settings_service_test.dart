import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/settings_service.dart';

void main() {
  group('SettingsService Unit Tests', () {
    late SettingsService settingsService;

    setUp(() {
      settingsService = SettingsService();
    });

    test('форматування валюти - гривня', () {
      settingsService.setCurrency('UAH');
      expect(settingsService.formatAmount(1500.0), '1,500 ₴');
      expect(settingsService.formatAmountShort(1500000.0), '1.5M ₴');
    });

    test('форматування валюти - долар', () {
      settingsService.setCurrency('USD');
      expect(settingsService.formatAmount(1500.0), '\$1,500');
      expect(settingsService.formatAmountShort(1500000.0), '\$1.5M');
    });

    test('форматування валюти - євро', () {
      settingsService.setCurrency('EUR');
      expect(settingsService.formatAmount(1500.0), '€1,500');
      expect(settingsService.formatAmountShort(1500000.0), '€1.5M');
    });

    test('перевірка валідних валют', () {
      expect(() => settingsService.setCurrency('UAH'), returnsNormally);
      expect(() => settingsService.setCurrency('USD'), returnsNormally);
      expect(() => settingsService.setCurrency('EUR'), returnsNormally);
    });

    test('перевірка невалідної валюти', () {
      expect(() => settingsService.setCurrency('XXX'), throwsException);
    });
  });
}