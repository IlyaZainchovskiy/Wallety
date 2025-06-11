import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:finance_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Інтеграційні тести додатку', () {
    testWidgets('повний сценарій додавання транзакції', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Тестова транзакція');
      await tester.enterText(find.byType(TextFormField).at(1), '1000');
      
      await tester.tap(find.byType(DropdownButtonFormField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Їжа').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Зберегти'));
      await tester.pumpAndSettle();

      expect(find.text('Тестова транзакція'), findsOneWidget);
      expect(find.text('-1,000 ₴'), findsOneWidget);
    });

    testWidgets('тест навігації між екранами', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Огляд'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pumpAndSettle();
      expect(find.text('Транзакції'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.pie_chart));
      await tester.pumpAndSettle();
      expect(find.text('Статистика'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.savings));
      await tester.pumpAndSettle();
      expect(find.text('Бюджети'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Налаштування'), findsOneWidget);
    });

    testWidgets('тест зміни теми', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

    });

    testWidgets('тест зміни мови', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });
  });
}