import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get dashboard => _isUkrainian ? 'Головна' : 'Dashboard';
  String get transactions => _isUkrainian ? 'Транзакції' : 'Transactions';
  String get statistics => _isUkrainian ? 'Статистика' : 'Statistics';
  String get budgets => _isUkrainian ? 'Бюджети' : 'Budgets';
  String get settings => _isUkrainian ? 'Налаштування' : 'Settings';

  String get cancel => _isUkrainian ? 'Скасувати' : 'Cancel';
  String get save => _isUkrainian ? 'Зберегти' : 'Save';
  String get delete => _isUkrainian ? 'Видалити' : 'Delete';
  String get edit => _isUkrainian ? 'Редагувати' : 'Edit';
  String get add => _isUkrainian ? 'Додати' : 'Add';
  String get loading => _isUkrainian ? 'Завантаження...' : 'Loading...';
  String get error => _isUkrainian ? 'Помилка' : 'Error';
  String get success => _isUkrainian ? 'Успішно' : 'Success';

  String get welcomeBack => _isUkrainian ? 'Вітаємо знову!' : 'Welcome Back!';
  String get signInToAccount => _isUkrainian ? 'Увійдіть до свого акаунта' : 'Sign in to your account';
  String get createAccount => _isUkrainian ? 'Створити акаунт' : 'Create Account';
  String get startFinancialJourney => _isUkrainian ? 'Почніть свій шлях до фінансової свободи' : 'Start your journey to financial freedom';
  String get email => _isUkrainian ? 'Email' : 'Email';
  String get password => _isUkrainian ? 'Пароль' : 'Password';
  String get confirmPassword => _isUkrainian ? 'Підтвердіть пароль' : 'Confirm Password';
  String get fullName => _isUkrainian ? 'Повне ім\'я' : 'Full Name';
  String get signIn => _isUkrainian ? 'Увійти' : 'Sign In';
  String get signUp => _isUkrainian ? 'Зареєструватися' : 'Sign Up';
  String get forgotPassword => _isUkrainian ? 'Забули пароль?' : 'Forgot Password?';

  String get addTransaction => _isUkrainian ? 'Додати транзакцію' : 'Add Transaction';
  String get income => _isUkrainian ? 'Дохід' : 'Income';
  String get expense => _isUkrainian ? 'Витрата' : 'Expense';
  String get amount => _isUkrainian ? 'Сума' : 'Amount';
  String get category => _isUkrainian ? 'Категорія' : 'Category';
  String get date => _isUkrainian ? 'Дата' : 'Date';
  String get description => _isUkrainian ? 'Опис' : 'Description';
  String get title => _isUkrainian ? 'Назва' : 'Title';
  String get type => _isUkrainian ? 'Тип' : 'Type';

  String get totalBalance => _isUkrainian ? 'Загальний баланс' : 'Total Balance';
  String get monthlyIncome => _isUkrainian ? 'Доходи цього місяця' : 'Monthly Income';
  String get monthlyExpenses => _isUkrainian ? 'Витрати цього місяця' : 'Monthly Expenses';
  String get recentTransactions => _isUkrainian ? 'Останні транзакції' : 'Recent Transactions';
  String get quickActions => _isUkrainian ? 'Швидкі дії' : 'Quick Actions';
  String get addIncome => _isUkrainian ? 'Додати дохід' : 'Add Income';
  String get addExpense => _isUkrainian ? 'Додати витрату' : 'Add Expense';
  String get showAll => _isUkrainian ? 'Показати всі' : 'Show All';

  String get profile => _isUkrainian ? 'Профіль' : 'Profile';
  String get appSettings => _isUkrainian ? 'Налаштування додатку' : 'App Settings';
  String get darkTheme => _isUkrainian ? 'Темна тема' : 'Dark Theme';
  String get language => _isUkrainian ? 'Мова' : 'Language';
  String get currency => _isUkrainian ? 'Валюта' : 'Currency';
  String get security => _isUkrainian ? 'Безпека' : 'Security';
  String get changePassword => _isUkrainian ? 'Змінити пароль' : 'Change Password';
  String get signOut => _isUkrainian ? 'Вийти з акаунта' : 'Sign Out';
  String get deleteAccount => _isUkrainian ? 'Видалити акаунт' : 'Delete Account';

  String get food => _isUkrainian ? 'Їжа' : 'Food';
  String get transport => _isUkrainian ? 'Транспорт' : 'Transport';
  String get entertainment => _isUkrainian ? 'Розваги' : 'Entertainment';
  String get utilities => _isUkrainian ? 'Комунальні' : 'Utilities';
  String get shopping => _isUkrainian ? 'Покупки' : 'Shopping';
  String get health => _isUkrainian ? 'Здоров\'я' : 'Health';
  String get education => _isUkrainian ? 'Освіта' : 'Education';
  String get other => _isUkrainian ? 'Інше' : 'Other';

  String get salary => _isUkrainian ? 'Зарплата' : 'Salary';
  String get bonus => _isUkrainian ? 'Бонус' : 'Bonus';
  String get investment => _isUkrainian ? 'Інвестиції' : 'Investment';

  String get ukrainianHryvnia => _isUkrainian ? 'Українська гривня (₴)' : 'Ukrainian Hryvnia (₴)';
  String get usDollar => _isUkrainian ? 'Долар США (\$)' : 'US Dollar (\$)';
  String get euro => _isUkrainian ? 'Євро (€)' : 'Euro (€)';

  String get ukrainian => _isUkrainian ? 'Українська' : 'Ukrainian';
  String get english => _isUkrainian ? 'English' : 'English';

  String get systemTheme => _isUkrainian ? 'Системна' : 'System';
  String get lightTheme => _isUkrainian ? 'Світла' : 'Light';
  String get darkThemeOption => _isUkrainian ? 'Темна' : 'Dark';

  String get addBudget => _isUkrainian ? 'Додати бюджет' : 'Add Budget';
  String get budgetAmount => _isUkrainian ? 'Сума бюджету' : 'Budget Amount';
  String get totalBudget => _isUkrainian ? 'Загальний бюджет' : 'Total Budget';
  String get spent => _isUkrainian ? 'Витрачено' : 'Spent';
  String get remaining => _isUkrainian ? 'Залишилось' : 'Remaining';

  String get noTransactions => _isUkrainian ? 'Поки що немає транзакцій' : 'No transactions yet';
  String get addFirstTransaction => _isUkrainian ? 'Додайте першу транзакцію' : 'Add your first transaction';
  String get noDataToDisplay => _isUkrainian ? 'Немає даних для відображення' : 'No data to display';
  
  String get month => _isUkrainian ? 'Місяць' : 'Month';
  String get year => _isUkrainian ? 'Рік' : 'Year';
  String get allTime => _isUkrainian ? 'Весь час' : 'All Time';


  String get sortByDate => _isUkrainian ? 'Сортувати за датою' : 'Sort by Date';
  String get sortByAmount => _isUkrainian ? 'Сортувати за сумою' : 'Sort by Amount';
  String get sortByCategory => _isUkrainian ? 'Сортувати за категорією' : 'Sort by Category';

  bool get _isUkrainian => locale.languageCode == 'uk';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['uk', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}