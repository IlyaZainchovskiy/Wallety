import 'package:finance_app/services/data_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  String _selectedCurrency = 'UAH';
  String _selectedLanguage = 'Ukrainian';

  @override
  void initState() {
    super.initState();
    _isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: ListView(
        children: [
          _buildProfileSection(),          
          const Divider(height: 32),
          _buildAppSettingsSection(),         

          const Divider(height: 32),
          _buildDataSection(),
          const Divider(height: 32),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Профіль',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Користувач FinMate',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'user@finmate.app',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showEditProfileDialog(),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Налаштування додатку',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        SwitchListTile(
          title: const Text('Темна тема'),
          subtitle: const Text('Використовувати темну тему оформлення'),
          secondary: const Icon(Icons.dark_mode_outlined),
          value: _isDarkTheme,
          onChanged: (value) {
            setState(() {
              _isDarkTheme = value;
            });
            // TODO: Реалізувати зміну теми
            _showSnackBar('Зміна теми буде доступна в наступному оновленні');
          },
        ),

        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: const Text('Валюта'),
          subtitle: Text(_getCurrencyName(_selectedCurrency)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCurrencyDialog(),
        ),

        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Мова'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(),
        ),
        
 
        SwitchListTile(
          title: const Text('Сповіщення'),
          subtitle: const Text('Отримувати нагадування про платежі'),
          secondary: const Icon(Icons.notifications_outlined),
          value: true,
          onChanged: (value) {
            _showSnackBar('Налаштування сповіщень буде доступне незабаром');
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Дані та резервне копіювання',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        

        ListTile(
          leading: const Icon(Icons.file_download_outlined),
          title: const Text('Експортувати дані'),
          subtitle: const Text('Зберегти транзакції у CSV файл'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _exportData(),
        ),
        

        ListTile(
          leading: const Icon(Icons.file_upload_outlined),
          title: const Text('Імпортувати дані'),
          subtitle: const Text('Завантажити дані з CSV файлу'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _importData(),
        ),
        

        ListTile(
          leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
          title: const Text('Очистити всі дані'),
          subtitle: const Text('Видалити всі транзакції та налаштування'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showClearDataDialog(),
        ),

        ListTile(
          leading: const Icon(Icons.data_usage_outlined),
          title: const Text('Генерувати тестові дані'),
          subtitle: const Text('Додати приклади транзакцій для демонстрації'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _generateSampleData(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Про додаток',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),

        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'FinMate',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2025 FinMate. Всі права захищені.',
          aboutBoxChildren: [
            Text('FinMate - ваш персональний помічник для управління фінансами.'),
            SizedBox(height: 8),
            Text('Відстежуйте витрати, плануйте бюджет та досягайте фінансових цілей.'),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Політика конфіденційності'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _showSnackBar('Відкриття політики конфіденційності...'),
        ),

        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Умови використання'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _showSnackBar('Відкриття умов використання...'),
        ),        
        ListTile(
          leading: const Icon(Icons.feedback_outlined),
          title: const Text('Залишити відгук'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showFeedbackDialog(),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редагувати профіль'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Ім\'я',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Профіль оновлено');
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оберіть валюту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Українська гривня (₴)'),
              value: 'UAH',
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Долар США (\$)'),
              value: 'USD',
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Євро (€)'),
              value: 'EUR',
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оберіть мову'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Українська'),
              value: 'Ukrainian',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистити всі дані'),
        content: const Text(
          'Ви впевнені, що хочете видалити всі транзакції та налаштування? '
          'Цю дію неможливо скасувати.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              DataService().transactions.clear();
              Navigator.of(context).pop();
              _showSnackBar('Всі дані видалено');
            },
            child: const Text('Видалити все'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Залишити відгук'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Ваш відгук',
            border: OutlineInputBorder(),
            hintText: 'Поділіться своїми враженнями про додаток...',
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Дякуємо за ваш відгук!');
            },
            child: const Text('Надіслати'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // TODO: Реалізувати експорт у CSV
    _showSnackBar('Експорт даних у CSV файл...');
  }

  void _importData() {
    // TODO: Реалізувати імпорт з CSV
    _showSnackBar('Функція імпорту буде доступна незабаром');
  }

  void _generateSampleData() {
    DataService().generateSampleData();
    _showSnackBar('Тестові дані згенеровано');
  }

  String _getCurrencyName(String code) {
    switch (code) {
      case 'UAH':
        return 'Українська гривня (₴)';
      case 'USD':
        return 'Долар США (\$)';
      case 'EUR':
        return 'Євро (€)';
      default:
        return code;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}