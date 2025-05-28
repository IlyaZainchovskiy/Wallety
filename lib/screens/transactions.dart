import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) {
          bool income = index.isOdd;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.fastfood_outlined, color: Colors.teal),
              ),
              title: const Text('Food'),
              subtitle: Text(DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]),
              trailing: Text(
                income ? '+\$ 120' : '-\$ 15',
                style: TextStyle(
                  color: income ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
