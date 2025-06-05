import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:finance_app/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseDataService extends ChangeNotifier {
  static final FirebaseDataService _instance = FirebaseDataService._internal();
  factory FirebaseDataService() => _instance;
  FirebaseDataService._internal();

  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Transaction> _transactions = [];
  Map<String, double> _budgets = {};
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  Map<String, double> get budgets => _budgets;
  bool get isLoading => _isLoading;

  String? get _userId => _auth.currentUser?.uid;

  firestore.CollectionReference get _transactionsCollection =>
      _firestore.collection('users').doc(_userId).collection('transactions');
  
  firestore.DocumentReference get _budgetsDocument =>
      _firestore.collection('users').doc(_userId);

  Future<void> initializeUserData() async {
    if (_userId == null) return;
    
    _setLoading(true);
    try {
      await Future.wait([
        _loadTransactions(),
        _loadBudgets(),
      ]);
    } catch (e) {
      debugPrint('Помилка ініціалізації даних: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadTransactions() async {
    if (_userId == null) return;

    try {
      final snapshot = await _transactionsCollection
          .orderBy('date', descending: true)
          .get();
      
      _transactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Transaction.fromJson(data);
      }).toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка завантаження транзакцій: $e');
      throw 'Помилка завантаження транзакцій';
    }
  }

  Future<void> _loadBudgets() async {
    if (_userId == null) return;

    try {
      final doc = await _budgetsDocument.get();
      final data = doc.data() as Map<String, dynamic>?;
      
      if (data != null && data['budgets'] != null) {
        _budgets = Map<String, double>.from(data['budgets']);
      } else {
        _budgets = {};
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка завантаження бюджетів: $e');
      _budgets = {};
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    if (_userId == null) throw 'Користувач не авторизований';

    try {
      final docRef = await _transactionsCollection.add(transaction.toJson());
      
      final newTransaction = Transaction(
        id: docRef.id,
        title: transaction.title,
        amount: transaction.amount,
        category: transaction.category,
        date: transaction.date,
        type: transaction.type,
        description: transaction.description,
      );
      
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка додавання транзакції: $e');
      throw 'Помилка додавання транзакції';
    }
  }

  Future<void> removeTransaction(String id) async {
    if (_userId == null) throw 'Користувач не авторизований';

    try {
      await _transactionsCollection.doc(id).delete();
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка видалення транзакції: $e');
      throw 'Помилка видалення транзакції';
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    if (_userId == null) throw 'Користувач не авторизований';

    try {
      await _transactionsCollection.doc(transaction.id).update(transaction.toJson());
      
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Помилка оновлення транзакції: $e');
      throw 'Помилка оновлення транзакції';
    }
  }

  Future<void> saveBudgets(Map<String, double> budgets) async {
    if (_userId == null) throw 'Користувач не авторизований';

    try {
      await _budgetsDocument.set({
        'budgets': budgets,
        'lastUpdated': firestore.FieldValue.serverTimestamp(),
      }, firestore.SetOptions(merge: true));
      
      _budgets = Map.from(budgets);
      notifyListeners();
    } catch (e) {
      debugPrint('Помилка збереження бюджетів: $e');
      throw 'Помилка збереження бюджетів';
    }
  }

  Future<void> addBudget(String category, double amount) async {
    _budgets[category] = amount;
    await saveBudgets(_budgets);
  }


  Future<void> removeBudget(String category) async {
    _budgets.remove(category);
    await saveBudgets(_budgets);
  }


  void clearData() {
    _transactions.clear();
    _budgets.clear();
    notifyListeners();
  }

  double get balance {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }

  Map<String, double> getExpensesByCategory() {
    Map<String, double> expenses = {};
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        expenses[transaction.category] = 
          (expenses[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return expenses;
  }

  double getMonthlyExpenses(DateTime month) {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.date.year == month.year &&
          transaction.date.month == month.month) {
        total += transaction.amount;
      }
    }
    return total;
  }

  double getMonthlyIncome(DateTime month) {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income &&
          transaction.date.year == month.year &&
          transaction.date.month == month.month) {
        total += transaction.amount;
      }
    }
    return total;
  }

  Future<void> generateSampleData() async {
    if (_userId == null) return;

    _setLoading(true);
    try {
      final random = Random();
      final categories = ['Їжа', 'Транспорт', 'Розваги', 'Комунальні', 'Покупки'];
      
      final incomeTransactions = [
        Transaction(
          id: '',
          title: 'Зарплата',
          amount: 15000,
          category: 'Зарплата',
          date: DateTime.now().subtract(const Duration(days: 5)),
          type: TransactionType.income,
        ),
        Transaction(
          id: '',
          title: 'Бонус',
          amount: 2000,
          category: 'Бонус',
          date: DateTime.now().subtract(const Duration(days: 15)),
          type: TransactionType.income,
        ),
      ];

      for (var transaction in incomeTransactions) {
        await addTransaction(transaction);
      }

      for (int i = 0; i < 10; i++) {
        final category = categories[random.nextInt(categories.length)];
        final amount = 50 + random.nextInt(500).toDouble();
        
        final transaction = Transaction(
          id: '',
          title: _getTitleForCategory(category),
          amount: amount,
          category: category,
          date: DateTime.now().subtract(Duration(days: random.nextInt(30))),
          type: TransactionType.expense,
        );
        
        await addTransaction(transaction);
      }

      final demoBudgets = {
        'Їжа': 3000.0,
        'Транспорт': 800.0,
        'Розваги': 1200.0,
        'Комунальні': 1500.0,
        'Покупки': 2000.0,
      };
      
      await saveBudgets(demoBudgets);
      
    } catch (e) {
      debugPrint('Помилка генерації демо-даних: $e');
    } finally {
      _setLoading(false);
    }
  }

  String _getTitleForCategory(String category) {
    switch (category) {
      case 'Їжа':
        return ['Ресторан', 'Продукти', 'Кафе', 'Доставка'][Random().nextInt(4)];
      case 'Транспорт':
        return ['Метро', 'Таксі', 'Бензин', 'Автобус'][Random().nextInt(4)];
      case 'Розваги':
        return ['Кіно', 'Концерт', 'Ігри', 'Книги'][Random().nextInt(4)];
      case 'Комунальні':
        return ['Електрика', 'Газ', 'Вода', 'Інтернет'][Random().nextInt(4)];
      case 'Покупки':
        return ['Одяг', 'Техніка', 'Дім', 'Подарунки'][Random().nextInt(4)];
      default:
        return 'Витрата';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    super.removeListener(listener);
  }
}

typedef VoidCallback = void Function();