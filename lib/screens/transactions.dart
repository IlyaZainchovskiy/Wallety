import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/models/transaction.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:finance_app/widgets/add_transaction_dialog.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final FirebaseDataService _dataService = FirebaseDataService();
  final SettingsService _settingsService = SettingsService();
  String _filterType = 'all'; 
  String _sortBy = 'date'; 

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

  List<Transaction> get _filteredTransactions {
    var transactions = _dataService.transactions;

    if (_filterType == 'income') {
      transactions = transactions.where((t) => t.type == TransactionType.income).toList();
    } else if (_filterType == 'expense') {
      transactions = transactions.where((t) => t.type == TransactionType.expense).toList();
    }

    switch (_sortBy) {
      case 'date':
        transactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'amount':
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'category':
        transactions.sort((a, b) => a.category.compareTo(b.category));
        break;
    }

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_dataService.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loading),
            ],
          ),
        ),
      );
    }

    final transactions = _filteredTransactions;
    final totalIncome = _dataService.transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = _dataService.transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactions),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Text(l10n.sortByDate),
              ),
              PopupMenuItem(
                value: 'amount',
                child: Text(l10n.sortByAmount),
              ),
              PopupMenuItem(
                value: 'category',
                child: Text(l10n.sortByCategory),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _dataService.initializeUserData();
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: l10n.incomes,
                          amount: totalIncome,
                          color: Colors.green,
                          icon: Icons.trending_up,
                          settingsService: _settingsService,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: l10n.expenses,
                          amount: totalExpense,
                          color: Colors.red,
                          icon: Icons.trending_down,
                          settingsService: _settingsService,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'all',
                        label: Text(l10n.allTransactions),
                        icon: const Icon(Icons.list),
                      ),
                      ButtonSegment(
                        value: 'income',
                        label: Text(l10n.incomes),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      ButtonSegment(
                        value: 'expense',
                        label: Text(l10n.expenses),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                    selected: {_filterType},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _filterType = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _filterType == 'all'
                                ? l10n.noTransactionsYet
                                : _filterType == 'income'
                                    ? l10n.noIncome
                                    : l10n.noExpenses,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.addFirstTransaction),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const AddTransactionDialog(),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addTransaction),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _TransactionCard(
                          transaction: transaction,
                          l10n: l10n,
                          settingsService: _settingsService,
                          onDelete: () => _deleteTransaction(transaction.id),
                          onEdit: () => _editTransaction(transaction),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTransaction(String id) async {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTransaction),
        content: Text(l10n.deleteTransactionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                await _dataService.removeTransaction(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.transactionDeleted),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.deletionError}: $e'),
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

  Future<void> _editTransaction(Transaction transaction) async {
    showDialog(
      context: context,
      builder: (context) => EditTransactionDialog(transaction: transaction),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final SettingsService settingsService;

  const _StatCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              settingsService.formatAmountShort(amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final AppLocalizations l10n;
  final SettingsService settingsService;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TransactionCard({
    Key? key,
    required this.transaction,
    required this.l10n,
    required this.settingsService,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Їжа':
      case 'Food':
        return Icons.fastfood;
      case 'Транспорт':
      case 'Transport':
        return Icons.directions_car;
      case 'Розваги':
      case 'Entertainment':
        return Icons.movie;
      case 'Комунальні':
      case 'Utilities':
        return Icons.home;
      case 'Покупки':
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Здоров\'я':
      case 'Health':
        return Icons.local_hospital;
      case 'Освіта':
      case 'Education':
        return Icons.school;
      case 'Зарплата':
      case 'Salary':
        return Icons.work;
      case 'Бонус':
      case 'Bonus':
        return Icons.card_giftcard;
      case 'Інвестиції':
      case 'Investment':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Leading icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${transaction.date.day.toString().padLeft(2, '0')}.${transaction.date.month.toString().padLeft(2, '0')}.${transaction.date.year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                  if (transaction.description != null && transaction.description!.isNotEmpty)
                    Text(
                      transaction.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${settingsService.formatAmountShort(transaction.amount)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, size: 18),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      onTap: onEdit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: onDelete,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditTransactionDialog extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionDialog({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late TransactionType _type;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description ?? '';
    _type = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _selectedDate = widget.transaction.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> _getExpenseCategories(AppLocalizations l10n) {
    return [l10n.food, l10n.transport, l10n.entertainment, l10n.utilities, 
            l10n.shopping, l10n.health, l10n.education, l10n.other];
  }
  
  List<String> _getIncomeCategories(AppLocalizations l10n) {
    return [l10n.salary, l10n.bonus, l10n.investment, l10n.other];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.editTransactionTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.type, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      SegmentedButton<TransactionType>(
                        segments: [
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text(l10n.expenseType),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          ButtonSegment(
                            value: TransactionType.income,
                            label: Text(l10n.incomeType),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                        selected: {_type},
                        onSelectionChanged: (Set<TransactionType> newSelection) {
                          setState(() {
                            _type = newSelection.first;
                            final categories = _type == TransactionType.expense
                                ? _getExpenseCategories(l10n)
                                : _getIncomeCategories(l10n);
                            _selectedCategory = categories.first;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.enterTransactionName;
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: l10n.amount,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.attach_money),
                          suffixText: SettingsService().getCurrencySymbol(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.enterAmount;
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return l10n.enterCorrectAmount;
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),                   
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: l10n.categoryLabel,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.category),
                        ),
                        items: (_type == TransactionType.expense
                                ? _getExpenseCategories(l10n)
                                : _getIncomeCategories(l10n))
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
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.dateLabel,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.descriptionOptional,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.notes),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _isLoading ? null : _updateTransaction,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.update),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTransaction() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        type: _type,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
      );

      await FirebaseDataService().updateTransaction(updatedTransaction);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.transactionUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.updateError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}