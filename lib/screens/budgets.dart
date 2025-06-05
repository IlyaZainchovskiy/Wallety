import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/models/category.dart';
import 'package:finance_app/models/transaction.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:flutter/material.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final FirebaseDataService _dataService = FirebaseDataService();
  final SettingsService _settingsService = SettingsService();

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

  Map<String, double> _getCurrentMonthExpenses() {
    final now = DateTime.now();
    final monthlyTransactions = _dataService.transactions.where((t) =>
        t.type == TransactionType.expense &&
        t.date.year == now.year &&
        t.date.month == now.month);

    Map<String, double> expenses = {};
    for (var transaction in monthlyTransactions) {
      expenses[transaction.category] =
          (expenses[transaction.category] ?? 0) + transaction.amount;
    }
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final budgets = _dataService.budgets;
    final currentExpenses = _getCurrentMonthExpenses();
    final now = DateTime.now();
    final monthName = l10n.getMonthName(now.month);

    if (_dataService.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loadingData),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBudgetDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.budgetFor} $monthName ${now.year}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.trackExpensesByCategory,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            if (budgets.isNotEmpty) ...[
              _buildOverallStats(currentExpenses, budgets, l10n),
              const SizedBox(height: 16),
              ...budgets.entries.map((entry) {
                final category = entry.key;
                final budgetLimit = entry.value;
                final spent = currentExpenses[category] ?? 0;
                final progress = spent / budgetLimit;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BudgetCard(
                    category: category,
                    spent: spent,
                    limit: budgetLimit,
                    progress: progress,
                    l10n: l10n,
                    settingsService: _settingsService,
                    onEdit: () => _showEditBudgetDialog(category, budgetLimit),
                    onDelete: () => _deleteBudget(category),
                  ),
                );
              }).toList(),
            ],
            
            Card(
              child: InkWell(
                onTap: () => _showAddBudgetDialog(),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        l10n.addNewBudget,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildOverallStats(Map<String, double> currentExpenses, Map<String, double> budgets, AppLocalizations l10n) {
    final totalBudget = budgets.values.fold(0.0, (sum, amount) => sum + amount);
    final totalSpent = currentExpenses.values.fold(0.0, (sum, amount) => sum + amount);
    final remaining = totalBudget - totalSpent;
    final overallProgress = totalSpent / totalBudget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overallView,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    title: l10n.totalBudget,
                    amount: totalBudget,
                    color: Colors.blue,
                    settingsService: _settingsService,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    title: l10n.budgetUsed,
                    amount: totalSpent,
                    color: Colors.orange,
                    settingsService: _settingsService,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    title: l10n.remaining,
                    amount: remaining,
                    color: remaining >= 0 ? Colors.green : Colors.red,
                    settingsService: _settingsService,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            LinearProgressIndicator(
              value: overallProgress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(
                overallProgress >= 1.0 ? Colors.red : 
                overallProgress >= 0.8 ? Colors.orange : Colors.green,
              ),
              minHeight: 8,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '${l10n.budgetUsed} ${(overallProgress * 100).toStringAsFixed(1)}% ${l10n.percentOfBudget}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddBudgetDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => _BudgetDialog(
        title: l10n.addBudget,
        l10n: l10n,
        onSave: (category, amount) async {
          try {
            await _dataService.addBudget(category, amount);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.budgetAdded),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.error}: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _showEditBudgetDialog(String category, double currentAmount) async {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => _BudgetDialog(
        title: l10n.editBudget,
        initialCategory: category,
        initialAmount: currentAmount,
        l10n: l10n,
        onSave: (newCategory, amount) async {
          try {
            if (newCategory != category) {
              await _dataService.removeBudget(category);
            }
            await _dataService.addBudget(newCategory, amount);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.budgetUpdated),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.error}: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _deleteBudget(String category) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedCategoryName = Categories.getLocalizedCategoryName(category, l10n);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBudget),
        content: Text('${l10n.deleteBudgetConfirm} "$localizedCategoryName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _dataService.removeBudget(category);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.budgetDeleted),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final SettingsService settingsService;

  const _StatItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          settingsService.formatAmountShort(amount),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  final double progress;
  final AppLocalizations l10n;
  final SettingsService settingsService;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    Key? key,
    required this.category,
    required this.spent,
    required this.limit,
    required this.progress,
    required this.l10n,
    required this.settingsService,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
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

  @override
  Widget build(BuildContext context) {
    final Color statusColor = progress >= 1.0
        ? Colors.red
        : progress >= 0.8
            ? Colors.orange
            : Colors.green;

    final localizedCategoryName = Categories.getLocalizedCategoryName(category, l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedCategoryName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${settingsService.formatAmountShort(spent)} ${AppLocalizations.of} ${settingsService.formatAmountShort(limit)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      onTap: onEdit,
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: onDelete,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(l10n.delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(statusColor),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% ${l10n.percentOfBudget}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                if (progress >= 1.0)
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.exceededBy} ${settingsService.formatAmountShort(spent - limit)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  )
                else
                  Text(
                    '${l10n.remainingAmount} ${settingsService.formatAmountShort(limit - spent)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetDialog extends StatefulWidget {
  final String title;
  final String? initialCategory;
  final double? initialAmount;
  final AppLocalizations l10n;
  final Future<void> Function(String category, double amount) onSave;

  const _BudgetDialog({
    Key? key,
    required this.title,
    this.initialCategory,
    this.initialAmount,
    required this.l10n,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedCategory = '';
  bool _isLoading = false;

  List<String> get _categories => Categories.getLocalizedExpenseCategories(widget.l10n);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory != null 
        ? Categories.getLocalizedCategoryName(widget.initialCategory!, widget.l10n)
        : _categories.first;
    
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _getCategoryKey(String localizedName) {
    // Знаходимо nameKey за локалізованою назвою
    for (final category in Categories.expense) {
      if (category.getLocalizedName(widget.l10n) == localizedName) {
        return category.nameKey;
      }
    }
    return 'other'; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: widget.l10n.category,
                border: const OutlineInputBorder(),
              ),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: widget.l10n.budgetAmount,
                border: const OutlineInputBorder(),
                suffixText: SettingsService().getCurrencySymbol(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.l10n.enterBudgetAmount;
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return widget.l10n.enterCorrectAmount;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _isLoading = true);
              
              try {
                final categoryKey = _getCategoryKey(_selectedCategory);
                await widget.onSave(categoryKey, double.parse(_amountController.text));
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            }
          },
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.l10n.save),
        ),
      ],
    );
  }
}