import 'package:flutter/material.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        const cats = ['Food', 'Transport', 'Entertainment', 'Utilities'];
        final spent = [200, 60, 80, 50][i];
        final limit = [500, 100, 150, 80][i];
        final progress = spent / limit;
        return Card(
          child: ListTile(
            title: Text(cats[i]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: progress, minHeight: 6),
                const SizedBox(height: 4),
                Text('\$ $spent of \$ $limit'),
              ],
            ),
            trailing: Icon(
              progress >= 1 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
              color: progress >= 1
                  ? Colors.red
                  : progress >= 0.8
                      ? Colors.orange
                      : Colors.green,
            ),
          ),
        );
      },
    );
  }
}
