import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/transaction.dart';

void main() {
  group('Тести безпеки та валідації даних', () {
    test('валідація XSS атак в назві транзакції', () {
      expect(
        () => Transaction(
          id: '1',
          title: '<script>alert("XSS")</script>',
          amount: 1000.0,
          category: 'test',
          type: TransactionType.income,
          date: DateTime.now(),
        ),
        returnsNormally, 
      );
    });

    test('валідація SQL ін\'єкцій в описі', () {
      expect(
        () => Transaction(
          id: '1',
          title: 'Тест',
          amount: 1000.0,
          category: 'test',
          type: TransactionType.income,
          date: DateTime.now(),
          description: "'; DROP TABLE transactions; --",
        ),
        returnsNormally, 
      );
    });

    test('валідація занадто довгих рядків', () {
      final longString = 'A' * 10000;
      
      expect(
        () => Transaction(
          id: '1',
          title: longString,
          amount: 1000.0,
          category: 'test',
          type: TransactionType.income,
          date: DateTime.now(),
        ),
        throwsException, 
      );
    });

    test('валідація екстремально великих сум', () {
      expect(
        () => Transaction(
          id: '1',
          title: 'Тест',
          amount: double.maxFinite,
          category: 'test',
          type: TransactionType.income,
          date: DateTime.now(),
        ),
        throwsException,
      );
    });

    test('валідація майбутніх дат', () {
      final futureDate = DateTime.now().add(const Duration(days: 365));
      
      expect(
        () => Transaction(
          id: '1',
          title: 'Майбутня транзакція',
          amount: 1000.0,
          category: 'test',
          type: TransactionType.income,
          date: futureDate,
        ),
        throwsException, 
      );
    });

    test('валідація порожніх обов\'язкових полів', () {
      expect(
        () => Transaction(
          id: '',
          title: '',
          amount: 1000.0,
          category: '',
          type: TransactionType.income,
          date: DateTime.now(),
        ),
        throwsException,
      );
    });
  });
}