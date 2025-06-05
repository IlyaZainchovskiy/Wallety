import 'package:finance_app/services/firebase_data.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final FirebaseDataService _dataService = FirebaseDataService();
  
  bool _isDarkTheme = false;
  String _selectedCurrency = 'UAH';
  String _selectedLanguage = 'Ukrainian';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('currency') ?? 'UAH';
      _selectedLanguage = prefs.getString('language') ?? 'Ukrainian';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', _selectedCurrency);
    await prefs.setString('language', _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: ListView(
        children: [
          _buildProfileSection(user),
          
          const Divider(height: 32),
          
          _buildAppSettingsSection(),
          
          const Divider(height: 32),
          
          _buildDataSection(),
          
          const Divider(height: 32),
          
          _buildSecuritySection(),
          
          const Divider(height: 32),
          
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection(user) {
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
                  backgroundImage: user?.photoURL != null 
                      ? NetworkImage(user!.photoURL!) 
                      : null,
                  child: user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 30,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? 'Користувач FinMate',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'user@finmate.app',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
        
        const ListTile(
          leading: Icon(Icons.cloud_upload_outlined),
          title: Text('Синхронізація з хмарою'),
          subtitle: Text('Дані автоматично синхронізуються'),
          trailing: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
      
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Безпека',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Змінити пароль'),
          subtitle: const Text('Оновити пароль акаунта'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _changePassword(),
        ),
        
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Вийти з акаунта'),
          subtitle: const Text('Завершити сеанс роботи'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _signOut(),
        ),
        
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Видалити акаунт'),
          subtitle: const Text('Остаточно видалити акаунт та всі дані'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _deleteAccount(),
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
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: _authService.currentUser?.displayName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редагувати профіль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ім\'я',
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
            onPressed: () async {
              try {
                await _authService.updateProfile(name: nameController.text);
                Navigator.of(context).pop();
                _showSnackBar('Профіль оновлено');
                setState(() {});
              } catch (e) {
                _showSnackBar('Помилка оновлення профілю: $e');
              }
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
                _saveSettings();
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
                _saveSettings();
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
                _saveSettings();
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
                _saveSettings();
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
                _saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    final emailController = TextEditingController(text: _authService.currentUser?.email);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Змінити пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const Text('Лист для скидання пароля буде надіслано на вашу пошту.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(emailController.text);
                Navigator.of(context).pop();
                _showSnackBar('Лист для скидання пароля надіслано');
              } catch (e) {
                _showSnackBar('Помилка: $e');
              }
            },
            child: const Text('Надіслати'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вийти з акаунта'),
        content: const Text('Ви впевнені, що хочете вийти з акаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                _dataService.clearData();
                await _authService.signOut();
              } catch (e) {
                _showSnackBar('Помилка виходу: $e');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалити акаунт'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'УВАГА! Це остаточно видалить ваш акаунт та всі дані. Цю дію неможливо скасувати.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Підтвердіть паролем',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                await _authService.reauthenticate(passwordController.text);
                await _authService.deleteAccount();
                _showSnackBar('Акаунт видалено');
              } catch (e) {
                _showSnackBar('Помилка видалення: $e');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Видалити назавжди'),
          ),
        ],
      ),
    );
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