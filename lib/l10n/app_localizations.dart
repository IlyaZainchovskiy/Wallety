import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Navigation
  String get dashboard => _isUkrainian ? 'Головна' : 'Dashboard';
  String get transactions => _isUkrainian ? 'Транзакції' : 'Transactions';
  String get statistics => _isUkrainian ? 'Статистика' : 'Statistics';
  String get budgets => _isUkrainian ? 'Бюджети' : 'Budgets';
  String get settings => _isUkrainian ? 'Налаштування' : 'Settings';

  // Common actions
  String get cancel => _isUkrainian ? 'Скасувати' : 'Cancel';
  String get save => _isUkrainian ? 'Зберегти' : 'Save';
  String get delete => _isUkrainian ? 'Видалити' : 'Delete';
  String get edit => _isUkrainian ? 'Редагувати' : 'Edit';
  String get add => _isUkrainian ? 'Додати' : 'Add';
  String get loading => _isUkrainian ? 'Завантаження...' : 'Loading...';
  String get error => _isUkrainian ? 'Помилка' : 'Error';
  String get success => _isUkrainian ? 'Успішно' : 'Success';

  // Auth
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

  // Transactions
  String get addTransaction => _isUkrainian ? 'Додати транзакцію' : 'Add Transaction';
  String get income => _isUkrainian ? 'Дохід' : 'Income';
  String get expense => _isUkrainian ? 'Витрата' : 'Expense';
  String get amount => _isUkrainian ? 'Сума' : 'Amount';
  String get category => _isUkrainian ? 'Категорія' : 'Category';
  String get date => _isUkrainian ? 'Дата' : 'Date';
  String get description => _isUkrainian ? 'Опис' : 'Description';
  String get title => _isUkrainian ? 'Назва' : 'Title';
  String get type => _isUkrainian ? 'Тип' : 'Type';

  // Dashboard
  String get totalBalance => _isUkrainian ? 'Загальний баланс' : 'Total Balance';
  String get monthlyIncome => _isUkrainian ? 'Доходи цього місяця' : 'Monthly Income';
  String get monthlyExpenses => _isUkrainian ? 'Витрати цього місяця' : 'Monthly Expenses';
  String get recentTransactions => _isUkrainian ? 'Останні транзакції' : 'Recent Transactions';
  String get quickActions => _isUkrainian ? 'Швидкі дії' : 'Quick Actions';
  String get addIncome => _isUkrainian ? 'Додати дохід' : 'Add Income';
  String get addExpense => _isUkrainian ? 'Додати витрату' : 'Add Expense';
  String get showAll => _isUkrainian ? 'Показати всі' : 'Show All';

  // Settings
  String get profile => _isUkrainian ? 'Профіль' : 'Profile';
  String get appSettings => _isUkrainian ? 'Налаштування додатку' : 'App Settings';
  String get darkTheme => _isUkrainian ? 'Темна тема' : 'Dark Theme';
  String get language => _isUkrainian ? 'Мова' : 'Language';
  String get currency => _isUkrainian ? 'Валюта' : 'Currency';
  String get security => _isUkrainian ? 'Безпека' : 'Security';
  String get changePassword => _isUkrainian ? 'Змінити пароль' : 'Change Password';
  String get signOut => _isUkrainian ? 'Вийти з акаунта' : 'Sign Out';
  String get deleteAccount => _isUkrainian ? 'Видалити акаунт' : 'Delete Account';

  // Categories
  String get food => _isUkrainian ? 'Їжа' : 'Food';
  String get transport => _isUkrainian ? 'Транспорт' : 'Transport';
  String get entertainment => _isUkrainian ? 'Розваги' : 'Entertainment';
  String get utilities => _isUkrainian ? 'Комунальні' : 'Utilities';
  String get shopping => _isUkrainian ? 'Покупки' : 'Shopping';
  String get health => _isUkrainian ? 'Здоров\'я' : 'Health';
  String get education => _isUkrainian ? 'Освіта' : 'Education';
  String get other => _isUkrainian ? 'Інше' : 'Other';

  // Income categories
  String get salary => _isUkrainian ? 'Зарплата' : 'Salary';
  String get bonus => _isUkrainian ? 'Бонус' : 'Bonus';
  String get investment => _isUkrainian ? 'Інвестиції' : 'Investment';

  // Currencies
  String get ukrainianHryvnia => _isUkrainian ? 'Українська гривня (₴)' : 'Ukrainian Hryvnia (₴)';
  String get usDollar => _isUkrainian ? 'Долар США (\$)' : 'US Dollar (\$)';
  String get euro => _isUkrainian ? 'Євро (€)' : 'Euro (€)';

  // Languages
  String get ukrainian => _isUkrainian ? 'Українська' : 'Ukrainian';
  String get english => _isUkrainian ? 'English' : 'English';

  // Themes
  String get systemTheme => _isUkrainian ? 'Системна' : 'System';
  String get lightTheme => _isUkrainian ? 'Світла' : 'Light';
  String get darkThemeOption => _isUkrainian ? 'Темна' : 'Dark';

  // Budgets
  String get addBudget => _isUkrainian ? 'Додати бюджет' : 'Add Budget';
  String get budgetAmount => _isUkrainian ? 'Сума бюджету' : 'Budget Amount';
  String get totalBudget => _isUkrainian ? 'Загальний бюджет' : 'Total Budget';
  String get spent => _isUkrainian ? 'Витрачено' : 'Spent';
  String get remaining => _isUkrainian ? 'Залишилось' : 'Remaining';

  // Empty states
  String get noTransactions => _isUkrainian ? 'Поки що немає транзакцій' : 'No transactions yet';
  String get addFirstTransaction => _isUkrainian ? 'Додайте першу транзакцію' : 'Add your first transaction';
  String get noDataToDisplay => _isUkrainian ? 'Немає даних для відображення' : 'No data to display';
  
  // Time periods
  String get month => _isUkrainian ? 'Місяць' : 'Month';
  String get year => _isUkrainian ? 'Рік' : 'Year';
  String get allTime => _isUkrainian ? 'Весь час' : 'All Time';

  // Sorting
  String get sortByDate => _isUkrainian ? 'Сортувати за датою' : 'Sort by Date';
  String get sortByAmount => _isUkrainian ? 'Сортувати за сумою' : 'Sort by Amount';
  String get sortByCategory => _isUkrainian ? 'Сортувати за категорією' : 'Sort by Category';

  // Welcome screen
  String get startWork => _isUkrainian ? 'Почати роботу' : 'Get Started';
  String get signInToAccount2 => _isUkrainian ? 'Увійти в акаунт' : 'Sign In to Account';
  String get yourPersonalFinancialAssistant => _isUkrainian ? 'Ваш персональний фінансовий помічник' : 'Your personal financial assistant';
  String get trackIncome => _isUkrainian ? 'Відстежуйте доходи' : 'Track Income';
  String get controlAllIncome => _isUkrainian ? 'Контролюйте всі ваші надходження' : 'Control all your income';
  String get analyzeExpenses => _isUkrainian ? 'Аналізуйте витрати' : 'Analyze Expenses';
  String get understandWhereMoneyGoes => _isUkrainian ? 'Зрозумійте, куди йдуть ваші гроші' : 'Understand where your money goes';
  String get planBudget => _isUkrainian ? 'Плануйте бюджет' : 'Plan Budget';
  String get achieveFinancialGoals => _isUkrainian ? 'Досягайте фінансових цілей' : 'Achieve financial goals';

  // Auth screens
  String get enterYourEmail => _isUkrainian ? 'Введіть ваш email' : 'Enter your email';
  String get enterYourPassword => _isUkrainian ? 'Введіть ваш пароль' : 'Enter your password';
  String get enterYourName => _isUkrainian ? 'Введіть ваше ім\'я' : 'Enter your name';
  String get createReliablePassword => _isUkrainian ? 'Створіть надійний пароль' : 'Create a reliable password';
  String get enterPasswordAgain => _isUkrainian ? 'Введіть пароль ще раз' : 'Enter password again';
  String get iAgreeWith => _isUkrainian ? 'Я погоджуюся з' : 'I agree with';
  String get termsOfUse => _isUkrainian ? 'Умовами використання' : 'Terms of Use';
  String get and => _isUkrainian ? 'та' : 'and';
  String get privacyPolicy => _isUkrainian ? 'Політикою конфіденційності' : 'Privacy Policy';
  String get createAccountButton => _isUkrainian ? 'Створити акаунт' : 'Create Account';
  String get or => _isUkrainian ? 'або' : 'or';
  String get noAccount => _isUkrainian ? 'Немає акаунта?' : 'No account?';
  String get alreadyHaveAccount => _isUkrainian ? 'Вже маєте акаунт?' : 'Already have an account?';
  String get needToAcceptTerms => _isUkrainian ? 'Потрібно прийняти умови використання' : 'Need to accept terms of use';
  String get enterEmailForReset => _isUkrainian ? 'Введіть email для скидання пароля' : 'Enter email for password reset';
  String get resetEmailSent => _isUkrainian ? 'Лист для скидання пароля надіслано на вашу пошту' : 'Password reset email sent to your email';

  // Validation messages
  String get enterEmail => _isUkrainian ? 'Введіть email' : 'Enter email';
  String get enterCorrectEmail => _isUkrainian ? 'Введіть коректний email' : 'Enter correct email';
  String get enterPassword => _isUkrainian ? 'Введіть пароль' : 'Enter password';
  String get enterYourName2 => _isUkrainian ? 'Введіть ваше ім\'я' : 'Enter your name';
  String get nameMinLength => _isUkrainian ? 'Ім\'я повинно містити мінімум 2 символи' : 'Name must contain at least 2 characters';
  String get passwordMinLength => _isUkrainian ? 'Пароль повинен містити мінімум 6 символів' : 'Password must contain at least 6 characters';
  String get confirmPassword2 => _isUkrainian ? 'Підтвердіть пароль' : 'Confirm password';
  String get passwordsDoNotMatch => _isUkrainian ? 'Паролі не співпадають' : 'Passwords do not match';
  String get enterTransactionName => _isUkrainian ? 'Введіть назву транзакції' : 'Enter transaction name';
  String get enterAmount => _isUkrainian ? 'Введіть суму' : 'Enter amount';
  String get enterCorrectAmount => _isUkrainian ? 'Введіть коректну суму' : 'Enter correct amount';
  String get enterBudgetAmount => _isUkrainian ? 'Введіть суму бюджету' : 'Enter budget amount';

  // Transaction dialog
  String get addTransactionTitle => _isUkrainian ? 'Додати транзакцію' : 'Add Transaction';
  String get editTransactionTitle => _isUkrainian ? 'Редагувати транзакцію' : 'Edit Transaction';
  String get expenseType => _isUkrainian ? 'Витрата' : 'Expense';
  String get incomeType => _isUkrainian ? 'Дохід' : 'Income';
  String get name => _isUkrainian ? 'Назва' : 'Name';
  String get categoryLabel => _isUkrainian ? 'Категорія' : 'Category';
  String get dateLabel => _isUkrainian ? 'Дата' : 'Date';
  String get descriptionOptional => _isUkrainian ? 'Опис (необов\'язково)' : 'Description (optional)';
  String get update => _isUkrainian ? 'Оновити' : 'Update';

  // Transaction screen
  String get allTransactions => _isUkrainian ? 'Всі' : 'All';
  String get incomes => _isUkrainian ? 'Доходи' : 'Income';
  String get expenses => _isUkrainian ? 'Витрати' : 'Expenses';
  String get noTransactionsYet => _isUkrainian ? 'Поки що немає транзакцій' : 'No transactions yet';
  String get noIncome => _isUkrainian ? 'Немає доходів' : 'No income';
  String get noExpenses => _isUkrainian ? 'Немає витрат' : 'No expenses';
  String get deleteTransaction => _isUkrainian ? 'Видалити транзакцію' : 'Delete Transaction';
  String get deleteTransactionConfirm => _isUkrainian ? 'Ви впевнені, що хочете видалити цю транзакцію?' : 'Are you sure you want to delete this transaction?';
  String get transactionDeleted => _isUkrainian ? 'Транзакцію видалено' : 'Transaction deleted';
  String get transactionUpdated => _isUkrainian ? 'Транзакцію оновлено' : 'Transaction updated';
  String get transactionAdded => _isUkrainian ? 'Транзакцію додано' : 'Transaction added';
  String get deletionError => _isUkrainian ? 'Помилка видалення' : 'Deletion error';
  String get updateError => _isUkrainian ? 'Помилка оновлення' : 'Update error';
  String get saveError => _isUkrainian ? 'Помилка збереження' : 'Save error';

  // Budget screen
  String get budgetFor => _isUkrainian ? 'Бюджет на' : 'Budget for';
  String get trackExpensesByCategory => _isUkrainian ? 'Відстежуйте свої витрати по категоріях' : 'Track your expenses by category';
  String get overallView => _isUkrainian ? 'Загальний огляд' : 'Overall View';
  String get budgetUsed => _isUkrainian ? 'Використано' : 'Used';
  String get percentOfBudget => _isUkrainian ? 'бюджету' : 'of budget';
  String get addNewBudget => _isUkrainian ? 'Додати новий бюджет' : 'Add New Budget';
  String get editBudget => _isUkrainian ? 'Редагувати бюджет' : 'Edit Budget';
  String get deleteBudget => _isUkrainian ? 'Видалити бюджет' : 'Delete Budget';
  String get deleteBudgetConfirm => _isUkrainian ? 'Ви впевнені, що хочете видалити бюджет для категорії' : 'Are you sure you want to delete budget for category';
  String get budgetAdded => _isUkrainian ? 'Бюджет додано' : 'Budget added';
  String get budgetUpdated => _isUkrainian ? 'Бюджет оновлено' : 'Budget updated';
  String get budgetDeleted => _isUkrainian ? 'Бюджет видалено' : 'Budget deleted';
  String get exceededBy => _isUkrainian ? 'Перевищено на' : 'Exceeded by';
  String get remainingAmount => _isUkrainian ? 'Залишилось' : 'Remaining';

  // Statistics screen
  String get expensesByCategory => _isUkrainian ? 'Витрати по категоріях' : 'Expenses by Category';
  String get expenseDetails => _isUkrainian ? 'Деталізація витрат' : 'Expense Details';
  String get period => _isUkrainian ? 'Період' : 'Period';
  String get monthPeriod => _isUkrainian ? 'Місяць' : 'Month';
  String get yearPeriod => _isUkrainian ? 'Рік' : 'Year';
  String get allTimePeriod => _isUkrainian ? 'Весь час' : 'All Time';
  String get noDataToShow => _isUkrainian ? 'Немає даних для відображення' : 'No data to display';
  String get addTransactionsToViewStats => _isUkrainian ? 'Додайте транзакції для перегляду статистики' : 'Add transactions to view statistics';

  // Settings screen
  String get editProfile => _isUkrainian ? 'Редагувати профіль' : 'Edit Profile';
  String get selectTheme => _isUkrainian ? 'Вибрати тему' : 'Select Theme';
  String get selectCurrency => _isUkrainian ? 'Вибрати валюту' : 'Select Currency';
  String get selectLanguage => _isUkrainian ? 'Вибрати мову' : 'Select Language';
  String get dataAndBackup => _isUkrainian ? 'Дані та резервне копіювання' : 'Data & Backup';
  String get cloudSync => _isUkrainian ? 'Синхронізація з хмарою' : 'Cloud Sync';
  String get dataAutomaticallySynced => _isUkrainian ? 'Дані автоматично синхронізуються' : 'Data automatically synced';
  String get updateAccountPassword => _isUkrainian ? 'Оновити пароль акаунта' : 'Update your account password';
  String get endCurrentSession => _isUkrainian ? 'Завершити поточну сесію' : 'End current session';
  String get permanentlyDeleteAccount => _isUkrainian ? 'Назавжди видалити акаунт та всі дані' : 'Permanently delete account and all data';
  String get about => _isUkrainian ? 'Про програму' : 'About';
  String get profileUpdated => _isUkrainian ? 'Профіль оновлено' : 'Profile updated';
  String get errorUpdatingProfile => _isUkrainian ? 'Помилка оновлення профілю' : 'Error updating profile';
  String get passwordResetEmailSent => _isUkrainian ? 'Лист для скидання пароля надіслано' : 'Password reset email sent';
  String get areYouSureSignOut => _isUkrainian ? 'Ви впевнені, що хочете вийти?' : 'Are you sure you want to sign out?';
  String get signOutError => _isUkrainian ? 'Помилка виходу' : 'Sign out error';
  String get passwordResetEmailWillBeSent => _isUkrainian ? 'Лист для скидання пароля буде надіслано на ваш email.' : 'A password reset email will be sent to your email.';
  String get send => _isUkrainian ? 'Надіслати' : 'Send';
  String get warning => _isUkrainian ? 'УВАГА! Це назавжди видалить ваш акаунт та всі дані. Цю дію неможливо скасувати.' : 'WARNING! This will permanently delete your account and all data. This action cannot be undone.';
  String get confirmWithPassword => _isUkrainian ? 'Підтвердіть паролем' : 'Confirm with password';
  String get deleteForever => _isUkrainian ? 'Видалити назавжди' : 'Delete Forever';
  String get accountDeleted => _isUkrainian ? 'Акаунт видалено' : 'Account deleted';
  String get deletionError2 => _isUkrainian ? 'Помилка видалення' : 'Deletion error';

  // Dashboard
  String get budgetNotifications => _isUkrainian ? 'Сповіщення про бюджет' : 'Budget Notifications';
  String get exceededBudgets => _isUkrainian ? 'Перевищені бюджети:' : 'Exceeded budgets:';
  String get warningBudgets => _isUkrainian ? 'Попередження (>80%):' : 'Warning (>80%):';
  String get allBudgetsWithinLimits => _isUkrainian ? 'Всі бюджети в межах лімітів!' : 'All budgets are within limits!';
  String get loadingData => _isUkrainian ? 'Завантаження даних...' : 'Loading data...';

  // Months
  String get january => _isUkrainian ? 'Січень' : 'January';
  String get february => _isUkrainian ? 'Лютий' : 'February';
  String get march => _isUkrainian ? 'Березень' : 'March';
  String get april => _isUkrainian ? 'Квітень' : 'April';
  String get may => _isUkrainian ? 'Травень' : 'May';
  String get june => _isUkrainian ? 'Червень' : 'June';
  String get july => _isUkrainian ? 'Липень' : 'July';
  String get august => _isUkrainian ? 'Серпень' : 'August';
  String get september => _isUkrainian ? 'Вересень' : 'September';
  String get october => _isUkrainian ? 'Жовтень' : 'October';
  String get november => _isUkrainian ? 'Листопад' : 'November';
  String get december => _isUkrainian ? 'Грудень' : 'December';

  String getMonthName(int month) {
    const ukrainianMonths = [
      'Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень',
      'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'
    ];
    
    const englishMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final months = _isUkrainian ? ukrainianMonths : englishMonths;
    return months[month - 1];
  }

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