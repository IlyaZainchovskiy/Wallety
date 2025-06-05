// lib/screens/statistics.dart
import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/models/category.dart';
import 'package:finance_app/models/transaction.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final FirebaseDataService _dataService = FirebaseDataService();
  final SettingsService _settingsService = SettingsService();
  String _selectedPeriod = 'month'; 

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Map<String, double> _getFilteredExpenses() {
    final now = DateTime.now();
    final transactions = _dataService.transactions.where((t) {
      if (t.type != TransactionType.expense) return false;
      
      switch (_selectedPeriod) {
        case 'month':
          return t.date.year == now.year && t.date.month == now.month;
        case 'year':
          return t.date.year == now.year;
        case 'all':
        default:
          return true;
      }
    }).toList();

    Map<String, double> expenses = {};
    for (var transaction in transactions) {
      expenses[transaction.category] = 
          (expenses[transaction.category] ?? 0) + transaction.amount;
    }
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenses = _getFilteredExpenses();
    final totalExpense = expenses.values.fold(0.0, (sum, amount) => sum + amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.period,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'month',
                          label: Text(l10n.monthPeriod),
                          icon: const Icon(Icons.calendar_view_month),
                        ),
                        ButtonSegment(
                          value: 'year',
                          label: Text(l10n.yearPeriod),
                          icon: const Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: 'all',
                          label: Text(l10n.allTimePeriod),
                          icon: const Icon(Icons.all_inclusive),
                        ),
                      ],
                      selected: {_selectedPeriod},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedPeriod = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            if (expenses.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.expensesByCategory,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomPaint(
                                painter: PieChartPainter(expenses, totalExpense, l10n, _settingsService),
                                child: const SizedBox.expand(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildLegend(expenses, totalExpense, l10n),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.expenseDetails,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ...expenses.entries
                          .map((entry) => _buildExpenseItem(
                                entry.key,
                                entry.value,
                                totalExpense,
                                l10n,
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ] else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.pie_chart_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noDataToShow,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addTransactionsToViewStats,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Map<String, double> expenses, double totalExpense, AppLocalizations l10n) {
    final colors = _getCategoryColors();
    final sortedEntries = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedEntries.map((entry) {
        final percentage = (entry.value / totalExpense * 100);
        final localizedCategoryName = Categories.getLocalizedCategoryName(entry.key, l10n);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[entry.key] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedCategoryName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpenseItem(String category, double amount, double totalExpense, AppLocalizations l10n) {
    final percentage = (amount / totalExpense * 100);
    final colors = _getCategoryColors();
    final localizedCategoryName = Categories.getLocalizedCategoryName(category, l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (colors[category] ?? Colors.grey).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: colors[category] ?? Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedCategoryName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(colors[category] ?? Colors.grey),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _settingsService.formatAmountShort(amount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    // Цей метод працює з nameKey, а не з локалізованими назвами
    switch (category) {
      case 'food':
      case 'Їжа':
      case 'Food':
        return Icons.fastfood;
      case 'transport':
      case 'Транспорт':
      case 'Transport':
        return Icons.directions_car;
      case 'entertainment':
      case 'Розваги':
      case 'Entertainment':
        return Icons.movie;
      case 'utilities':
      case 'Комунальні':
      case 'Utilities':
        return Icons.home;
      case 'shopping':
      case 'Покупки':
      case 'Shopping':
        return Icons.shopping_bag;
      case 'health':
      case 'Здоров\'я':
      case 'Health':
        return Icons.local_hospital;
      case 'education':
      case 'Освіта':
      case 'Education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Map<String, Color> _getCategoryColors() {
    return {
      // Підтримуємо як nameKey, так і локалізовані назви для зворотної сумісності
      'food': Colors.orange,
      'Їжа': Colors.orange,
      'Food': Colors.orange,
      
      'transport': Colors.blue,
      'Транспорт': Colors.blue,
      'Transport': Colors.blue,
      
      'entertainment': Colors.purple,
      'Розваги': Colors.purple,
      'Entertainment': Colors.purple,
      
      'utilities': Colors.green,
      'Комунальні': Colors.green,
      'Utilities': Colors.green,
      
      'shopping': Colors.pink,
      'Покупки': Colors.pink,
      'Shopping': Colors.pink,
      
      'health': Colors.red,
      'Здоров\'я': Colors.red,
      'Health': Colors.red,
      
      'education': Colors.indigo,
      'Освіта': Colors.indigo,
      'Education': Colors.indigo,
      
      'other': Colors.grey,
      'Інше': Colors.grey,
      'Other': Colors.grey,
    };
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final double totalValue;
  final AppLocalizations l10n;
  final SettingsService settingsService;

  PieChartPainter(this.data, this.totalValue, this.l10n, this.settingsService);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    final colors = {
      'food': Colors.orange,
      'Їжа': Colors.orange,
      'Food': Colors.orange,
      
      'transport': Colors.blue,
      'Транспорт': Colors.blue,
      'Transport': Colors.blue,
      
      'entertainment': Colors.purple,
      'Розваги': Colors.purple,
      'Entertainment': Colors.purple,
      
      'utilities': Colors.green,
      'Комунальні': Colors.green,
      'Utilities': Colors.green,
      
      'shopping': Colors.pink,
      'Покупки': Colors.pink,
      'Shopping': Colors.pink,
      
      'health': Colors.red,
      'Здоров\'я': Colors.red,
      'Health': Colors.red,
      
      'education': Colors.indigo,
      'Освіта': Colors.indigo,
      'Education': Colors.indigo,
      
      'other': Colors.grey,
      'Інше': Colors.grey,
      'Other': Colors.grey,
    };

    double startAngle = -math.pi / 2;
    
    for (final entry in data.entries) {
      final sweepAngle = (entry.value / totalValue) * 2 * math.pi;
      
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }
    
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, innerPaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${settingsService.formatAmountShort(totalValue)}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}