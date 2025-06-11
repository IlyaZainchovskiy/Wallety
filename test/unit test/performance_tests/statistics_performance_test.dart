import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/transaction.dart';

void main() {
  group('Тести продуктивності статистики', () {
    test('обчислення статистики для великої кількості транзакцій', () {
      final stopwatch = Stopwatch()..start();
      
      final transactions = List.generate(10000, (index) => Transaction(
        id: 'test-$index',
        title: 'Транзакція $index',
        amount: (index % 1000) + 100.0,
        category: ['food', 'transport', 'entertainment'][index % 3],
        type: index % 2 == 0 ? TransactionType.expense : TransactionType.income,
        date: DateTime.now().subtract(Duration(days: index % 365)),
      ));

      final expensesByCategory = <String, double>{};
      for (var transaction in transactions.where((t) => t.type == TransactionType.expense)) {
        expensesByCategory[transaction.category] = 
            (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
      }

      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(expensesByCategory.isNotEmpty, true);
      
      print('Час обчислення статистики для 10k транзакцій: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('продуктивність фільтрації транзакцій', () {
      final stopwatch = Stopwatch()..start();
      
      final transactions = List.generate(50000, (index) => Transaction(
        id: 'test-$index',
        title: 'Транзакція $index',
        amount: (index % 1000) + 100.0,
        category: 'food',
        type: TransactionType.expense,
        date: DateTime.now().subtract(Duration(days: index % 30)),
      ));

      final now = DateTime.now();
      final monthlyTransactions = transactions.where((t) =>
          t.date.year == now.year && t.date.month == now.month).toList();

      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
      expect(monthlyTransactions.isNotEmpty, true);
      
      print('Час фільтрації 50k транзакцій: ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}