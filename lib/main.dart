import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/screens/auth_wrapper.dart';
import 'package:finance_app/screens/auth/login.dart';
import 'package:finance_app/screens/auth/register.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/navigation_service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  
  await SettingsService().loadSettings();
  
  runApp(const FinMateApp());
}

class FinMateApp extends StatelessWidget {
  const FinMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService(),
      builder: (context, child) {
        final settingsService = SettingsService();
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FinMate',
          
          locale: settingsService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('uk'),
            Locale('en'),
          ],
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: settingsService.themeMode,
          
          home: const AuthWrapper(),
          routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 80,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(size: 24);
          }
          return const IconThemeData(size: 22);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 80,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(size: 24);
          }
          return const IconThemeData(size: 22);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
      ),
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_vert_circle_outlined),
            selectedIcon: const Icon(Icons.swap_vert_circle),
            label: l10n.transactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.budgets,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton.extended(
              tooltip: l10n.addTransaction,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddTransactionDialog(),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.add),
            )
          : null,
    );
  }
}