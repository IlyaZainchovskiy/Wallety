import 'package:finance_app/screens/auth_wrapper.dart';
import 'package:finance_app/screens/auth/login.dart';
import 'package:finance_app/screens/auth/register.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/dashboard.dart';
import 'screens/transactions.dart';
import 'screens/statistics.dart';
import 'screens/budgets.dart';
import 'screens/settings.dart';
import 'widgets/add_transaction_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, 
          brightness: Brightness.dark,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
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
  final NavigationService _navigationService = NavigationService();

  @override
  void initState() {
    super.initState();
    FirebaseDataService().addListener(_onDataChanged);
    _navigationService.setNavigationCallback(navigateToTab);
  }

  @override
  void dispose() {
    FirebaseDataService().removeListener(_onDataChanged);
    _navigationService.clearNavigationCallback();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void navigateToTab(int tabIndex) {
    setState(() {
      _index = tabIndex;
    });
  }

  List<Widget> get _screens => [
    const DashboardScreen(),
    const TransactionsScreen(),
    const StatisticsScreen(),
    const BudgetsScreen(),
    const SettingsScreen(),
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
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_vert_circle_outlined),
            selectedIcon: Icon(Icons.swap_vert_circle),
            label: 'Транзакції',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Статистика',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Бюджети',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Налаштування',
          ),
        ],
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton.extended(
              tooltip: 'Додати транзакцію',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddTransactionDialog(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Додати'),
            )
          : null,
    );
  }
}