import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get dashboard => locale.languageCode == 'uk' ? 'Головна' : 'Dashboard';
  String get transactions => locale.languageCode == 'uk' ? 'Транзакції' : 'Transactions';
  String get statistics => locale.languageCode == 'uk' ? 'Статистика' : 'Statistics';
  String get budgets => locale.languageCode == 'uk' ? 'Бюджети' : 'Budgets';
  String get settings => locale.languageCode == 'uk' ? 'Налаштування' : 'Settings';

  String get cancel => locale.languageCode == 'uk' ? 'Скасувати' : 'Cancel';
  String get save => locale.languageCode == 'uk' ? 'Зберегти' : 'Save';
  String get delete => locale.languageCode == 'uk' ? 'Видалити' : 'Delete';
  String get edit => locale.languageCode == 'uk' ? 'Редагувати' : 'Edit';
  String get add => locale.languageCode == 'uk' ? 'Додати' : 'Add';
  String get loading => locale.languageCode == 'uk' ? 'Завантаження...' : 'Loading...';
  String get error => locale.languageCode == 'uk' ? 'Помилка' : 'Error';
  String get success => locale.languageCode == 'uk' ? 'Успішно' : 'Success';

  String get welcomeBack => locale.languageCode == 'uk' ? 'Вітаємо знову!' : 'Welcome Back!';
  String get signInToAccount => locale.languageCode == 'uk' ? 'Увійдіть до свого акаунта' : 'Sign in to your account';
  String get createAccount => locale.languageCode == 'uk' ? 'Створити акаунт' : 'Create Account';
  String get startFinancialJourney => locale.languageCode == 'uk' ? 'Почніть свій шлях до фінансової свободи' : 'Start your journey to financial freedom';
  String get email => locale.languageCode == 'uk' ? 'Email' : 'Email';
  String get password => locale.languageCode == 'uk' ? 'Пароль' : 'Password';
  String get confirmPassword => locale.languageCode == 'uk' ? 'Підтвердіть пароль' : 'Confirm Password';
  String get fullName => locale.languageCode == 'uk' ? 'Повне ім\'я' : 'Full Name';
  String get signIn => locale.languageCode == 'uk' ? 'Увійти' : 'Sign In';
  String get signUp => locale.languageCode == 'uk' ? 'Зареєструватися' : 'Sign Up';
  String get forgotPassword => locale.languageCode == 'uk' ? 'Забули пароль?' : 'Forgot Password?';

  String get addTransaction => locale.languageCode == 'uk' ? 'Додати транзакцію' : 'Add Transaction';
  String get income => locale.languageCode == 'uk' ? 'Дохід' : 'Income';
  String get expense => locale.languageCode == 'uk' ? 'Витрата' : 'Expense';
  String get amount => locale.languageCode == 'uk' ? 'Сума' : 'Amount';
  String get category => locale.languageCode == 'uk' ? 'Категорія' : 'Category';
  String get date => locale.languageCode == 'uk' ? 'Дата' : 'Date';
  String get description => locale.languageCode == 'uk' ? 'Опис' : 'Description';
  String get title => locale.languageCode == 'uk' ? 'Назва' : 'Title';
  String get type => locale.languageCode == 'uk' ? 'Тип' : 'Type';

  String get totalBalance => locale.languageCode == 'uk' ? 'Загальний баланс' : 'Total Balance';
  String get monthlyIncome => locale.languageCode == 'uk' ? 'Доходи цього місяця' : 'Monthly Income';
  String get monthlyExpenses => locale.languageCode == 'uk' ? 'Витрати цього місяця' : 'Monthly Expenses';
  String get recentTransactions => locale.languageCode == 'uk' ? 'Останні транзакції' : 'Recent Transactions';
  String get quickActions => locale.languageCode == 'uk' ? 'Швидкі дії' : 'Quick Actions';
  String get addIncome => locale.languageCode == 'uk' ? 'Додати дохід' : 'Add Income';
  String get addExpense => locale.languageCode == 'uk' ? 'Додати витрату' : 'Add Expense';
  String get showAll => locale.languageCode == 'uk' ? 'Показати всі' : 'Show All';

  String get profile => locale.languageCode == 'uk' ? 'Профіль' : 'Profile';
  String get appSettings => locale.languageCode == 'uk' ? 'Налаштування додатку' : 'App Settings';
  String get darkTheme => locale.languageCode == 'uk' ? 'Темна тема' : 'Dark Theme';
  String get language => locale.languageCode == 'uk' ? 'Мова' : 'Language';
  String get currency => locale.languageCode == 'uk' ? 'Валюта' : 'Currency';
  String get security => locale.languageCode == 'uk' ? 'Безпека' : 'Security';
  String get changePassword => locale.languageCode == 'uk' ? 'Змінити пароль' : 'Change Password';
  String get signOut => locale.languageCode == 'uk' ? 'Вийти з акаунта' : 'Sign Out';
  String get deleteAccount => locale.languageCode == 'uk' ? 'Видалити акаунт' : 'Delete Account';

  String get food => locale.languageCode == 'uk' ? 'Їжа' : 'Food';
  String get transport => locale.languageCode == 'uk' ? 'Транспорт' : 'Transport';
  String get entertainment => locale.languageCode == 'uk' ? 'Розваги' : 'Entertainment';
  String get utilities => locale.languageCode == 'uk' ? 'Комунальні' : 'Utilities';
  String get shopping => locale.languageCode == 'uk' ? 'Покупки' : 'Shopping';
  String get health => locale.languageCode == 'uk' ? 'Здоров\'я' : 'Health';
  String get education => locale.languageCode == 'uk' ? 'Освіта' : 'Education';
  String get other => locale.languageCode == 'uk' ? 'Інше' : 'Other';

  String get salary => locale.languageCode == 'uk' ? 'Зарплата' : 'Salary';
  String get bonus => locale.languageCode == 'uk' ? 'Бонус' : 'Bonus';
  String get investment => locale.languageCode == 'uk' ? 'Інвестиції' : 'Investment';

  String get ukrainianHryvnia => locale.languageCode == 'uk' ? 'Українська гривня (₴)' : 'Ukrainian Hryvnia (₴)';
  String get usDollar => locale.languageCode == 'uk' ? 'Долар США (\$)' : 'US Dollar (\$)';
  String get euro => locale.languageCode == 'uk' ? 'Євро (€)' : 'Euro (€)';

  String get ukrainian => locale.languageCode == 'uk' ? 'Українська' : 'Ukrainian';
  String get english => locale.languageCode == 'uk' ? 'English' : 'English';

  String get systemTheme => locale.languageCode == 'uk' ? 'Системна' : 'System';
  String get lightTheme => locale.languageCode == 'uk' ? 'Світла' : 'Light';
  String get darkThemeOption => locale.languageCode == 'uk' ? 'Темна' : 'Dark';

  String get addBudget => locale.languageCode == 'uk' ? 'Додати бюджет' : 'Add Budget';
  String get budgetAmount => locale.languageCode == 'uk' ? 'Сума бюджету' : 'Budget Amount';
  String get totalBudget => locale.languageCode == 'uk' ? 'Загальний бюджет' : 'Total Budget';
  String get spent => locale.languageCode == 'uk' ? 'Витрачено' : 'Spent';
  String get remaining => locale.languageCode == 'uk' ? 'Залишилось' : 'Remaining';

  String get noTransactions => locale.languageCode == 'uk' ? 'Поки що немає транзакцій' : 'No transactions yet';
  String get addFirstTransaction => locale.languageCode == 'uk' ? 'Додайте першу транзакцію' : 'Add your first transaction';
  String get noDataToDisplay => locale.languageCode == 'uk' ? 'Немає даних для відображення' : 'No data to display';
  
  String get month => locale.languageCode == 'uk' ? 'Місяць' : 'Month';
  String get year => locale.languageCode == 'uk' ? 'Рік' : 'Year';
  String get allTime => locale.languageCode == 'uk' ? 'Весь час' : 'All Time';

  String get sortByDate => locale.languageCode == 'uk' ? 'Сортувати за датою' : 'Sort by Date';
  String get sortByAmount => locale.languageCode == 'uk' ? 'Сортувати за сумою' : 'Sort by Amount';
  String get sortByCategory => locale.languageCode == 'uk' ? 'Сортувати за категорією' : 'Sort by Category';
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