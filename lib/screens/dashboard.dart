import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/models/transaction.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/navigation_service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:finance_app/widgets/add_transaction_dialog.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseDataService _dataService = FirebaseDataService();
  final NavigationService _navigationService = NavigationService();
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

  void _navigateToTab(int tabIndex) {
    _navigationService.navigateToTab(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final balance = _dataService.balance;
    final currentMonth = DateTime.now();
    final monthlyExpenses = _dataService.getMonthlyExpenses(currentMonth);
    final monthlyIncome = _dataService.getMonthlyIncome(currentMonth);

    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('FinMate'),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showBudgetNotifications(l10n);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await _dataService.initializeUserData();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _BalanceCard(
                    total: balance,
                    l10n: l10n,
                    settingsService: _settingsService,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MonthlyCard(
                          title: l10n.monthlyIncome,
                          amount: monthlyIncome,
                          icon: Icons.trending_up,
                          color: Colors.green,
                          settingsService: _settingsService,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MonthlyCard(
                          title: l10n.monthlyExpenses,
                          amount: monthlyExpenses,
                          icon: Icons.trending_down,
                          color: Colors.red,
                          settingsService: _settingsService,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _RecentTransactionsCard(l10n: l10n, settingsService: _settingsService),
                  const SizedBox(height: 16),

                  _QuickActionsCard(l10n: l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBudgetNotifications(AppLocalizations l10n) {
    final budgets = _dataService.budgets;
    final currentMonth = DateTime.now();
    
    final monthlyExpenses = <String, double>{};
    for (var transaction in _dataService.transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.date.year == currentMonth.year &&
          transaction.date.month == currentMonth.month) {
        monthlyExpenses[transaction.category] =
            (monthlyExpenses[transaction.category] ?? 0) + transaction.amount;
      }
    }

    final exceededBudgets = <String>[];
    final warningBudgets = <String>[];

    for (var entry in budgets.entries) {
      final spent = monthlyExpenses[entry.key] ?? 0;
      final limit = entry.value;
      final percentage = spent / limit;

      if (percentage >= 1.0) {
        exceededBudgets.add(entry.key);
      } else if (percentage >= 0.8) {
        warningBudgets.add(entry.key);
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.orange),
            SizedBox(width: 8),
            Text('Budget Notifications'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exceededBudgets.isNotEmpty) ...[
              const Text(
                '⚠️ Exceeded budgets:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              ...exceededBudgets.map((category) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('• $category'),
                  )),
              const SizedBox(height: 12),
            ],
            if (warningBudgets.isNotEmpty) ...[
              const Text(
                '⚠️ Warning (>80%):',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              ...warningBudgets.map((category) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('• $category'),
                  )),
              const SizedBox(height: 12),
            ],
            if (exceededBudgets.isEmpty && warningBudgets.isEmpty)
              const Text(
                '✅ All budgets are within limits!',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double total;
  final AppLocalizations l10n;
  final SettingsService settingsService;

  const _BalanceCard({
    Key? key,
    required this.total,
    required this.l10n,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  const Spacer(),
                  Icon(
                    total >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.totalBalance,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                settingsService.formatAmount(total),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final SettingsService settingsService;

  const _MonthlyCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              settingsService.formatAmountShort(amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

class _RecentTransactionsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final SettingsService settingsService;

  const _RecentTransactionsCard({
    Key? key,
    required this.l10n,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions = FirebaseDataService().transactions
        .take(5)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.recentTransactions,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => NavigationService().navigateToTab(1),
                  child: Text(l10n.showAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.noTransactions),
                ),
              )
            else
              ...transactions.map((transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: transaction.type == TransactionType.income
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            transaction.type == TransactionType.income
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: transaction.type == TransactionType.income
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                transaction.category,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${transaction.type == TransactionType.income ? '+' : '-'}${settingsService.formatAmountShort(transaction.amount)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: transaction.type == TransactionType.income
                                    ? Colors.green
                                    : Colors.red,
                              ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _QuickActionsCard({
    Key? key,
    required this.l10n,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: l10n.addIncome,
                    color: Colors.green,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddTransactionDialog(
                          initialType: TransactionType.income,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.remove_circle_outline,
                    label: l10n.addExpense,
                    color: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddTransactionDialog(
                          initialType: TransactionType.expense,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.pie_chart_outline,
                    label: l10n.statistics,
                    color: Colors.blue,
                    onTap: () => NavigationService().navigateToTab(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.account_balance_wallet_outlined,
                    label: l10n.budgets,
                    color: Colors.orange,
                    onTap: () => NavigationService().navigateToTab(3),
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

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}