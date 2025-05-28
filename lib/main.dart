import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/transactions.dart';
import 'screens/statistics.dart';
import 'screens/budgets.dart';
import 'screens/settings.dart';

void main() {
  runApp(const FinMateApp());
}

class FinMateApp extends StatelessWidget {
  const FinMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    StatisticsScreen(),
    BudgetsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.swap_vert_circle_outlined), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.pie_chart_outline), label: 'Statistics'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Budgets'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton(
              tooltip: 'Add transaction',
              onPressed: () {
                // TODO: open add transaction dialog
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
