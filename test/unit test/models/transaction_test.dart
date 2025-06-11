import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/transaction.dart';

void main() {
  group('Transaction Model Tests', () {
    test('створення валідної транзакції доходу', () {
      final transaction = Transaction(
        id: '1',
        title: 'Зарплата',
        amount: 50000.0,
        category: 'salary',
        type: TransactionType.income,
        date: DateTime.now(),
      );

      expect(transaction.id, '1');
      expect(transaction.title, 'Зарплата');
      expect(transaction.amount, 50000.0);
      expect(transaction.type, TransactionType.income);
    });

    test('створення валідної транзакції витрати', () {
      final transaction = Transaction(
        id: '2',
        title: 'Продукти',
        amount: 800.0,
        category: 'food',
        type: TransactionType.expense,
        date: DateTime.now(),
        description: 'Покупка в супермаркеті',
      );

      expect(transaction.type, TransactionType.expense);
      expect(transaction.description, 'Покупка в супермаркеті');
    });

    test('перетворення в JSON та назад', () {
      final originalTransaction = Transaction(
        id: '3',
        title: 'Тест',
        amount: 1000.0,
        category: 'test',
        type: TransactionType.income,
        date: DateTime(2025, 6, 6),
      );

      final json = originalTransaction.toJson();
      final reconstructedTransaction = Transaction.fromJson(json);

      expect(reconstructedTransaction.id, originalTransaction.id);
      expect(reconstructedTransaction.title, originalTransaction.title);
      expect(reconstructedTransaction.amount, originalTransaction.amount);
      expect(reconstructedTransaction.type, originalTransaction.type);
    });

    test('валідація негативної суми', () {
      expect(
        () => Transaction(
          id: '4',
          title: 'Негативна сума',
          amount: -100.0,
          category: 'test',
          type: TransactionType.income,
          date: DateTime.now(),
        ),
        throwsException,
      );
    });
  });
}