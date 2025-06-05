import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/models/transaction.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransactionDialog extends StatefulWidget {
  final TransactionType? initialType;
  
  const AddTransactionDialog({
    Key? key,
    this.initialType,
  }) : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
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
    _type = widget.initialType ?? TransactionType.expense;
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
    
    // Ініціалізуємо категорію при першому рендері
    if (_selectedCategory.isEmpty) {
      _selectedCategory = _type == TransactionType.expense
          ? _getExpenseCategories(l10n).first
          : _getIncomeCategories(l10n).first;
    }
    
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
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.addTransactionTitle,
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
                            _selectedCategory = _type == TransactionType.expense
                                ? _getExpenseCategories(l10n).first
                                : _getIncomeCategories(l10n).first;
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
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
                    onPressed: _isLoading ? null : _saveTransaction,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final transaction = Transaction(
        id: '', 
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        type: _type,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
      );

      await FirebaseDataService().addTransaction(transaction);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.transactionAdded} "${transaction.title}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.saveError}: $e'),
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