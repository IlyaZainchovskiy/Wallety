import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(milliseconds: 500)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _BalanceCard(total: 13720.0),
            SizedBox(height: 12),
            _WeeklySpendingCard(spent: 400, budget: 1000),
            SizedBox(height: 12),
            _UpcomingPaymentCard(),
            SizedBox(height: 12),
            _PlaceholderChartCard(),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double total;
  const _BalanceCard({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('\$ ${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _WeeklySpendingCard extends StatelessWidget {
  final double spent;
  final double budget;
  const _WeeklySpendingCard({Key? key, required this.spent, required this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = spent / budget;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending this week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 8),
            Text('\$ ${spent.toStringAsFixed(0)} of \$ ${budget.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _UpcomingPaymentCard extends StatelessWidget {
  const _UpcomingPaymentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.schedule, color: Colors.white),
        ),
        title: const Text('Internet bill'),
        subtitle: const Text('Pay by 22 Apr'),
        trailing: const Text('\$ 120'),
      ),
    );
  }
}

class _PlaceholderChartCard extends StatelessWidget {
  const _PlaceholderChartCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text('Spending by category chart here', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
