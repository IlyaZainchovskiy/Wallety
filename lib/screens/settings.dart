import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:finance_app/services/settings_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final FirebaseDataService _dataService = FirebaseDataService();
  final SettingsService _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListenableBuilder(
        listenable: _settingsService,
        builder: (context, child) {
          return ListView(
            children: [
              _buildProfileSection(user, l10n),
              
              const Divider(height: 32),
              
              _buildAppSettingsSection(l10n),
              
              const Divider(height: 32),
              
              _buildDataSection(l10n),
              
              const Divider(height: 32),
              
              _buildSecuritySection(l10n),
              
              const Divider(height: 32),
              
              _buildAboutSection(l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(user, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.profile,
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
                        user?.displayName ?? 'FinMate User',
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
                  onPressed: () => _showEditProfileDialog(l10n),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            l10n.appSettings,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.darkTheme),
          subtitle: Text(_getThemeName(l10n)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(l10n),
        ),
        
        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: Text(l10n.currency),
          subtitle: Text(_settingsService.getCurrencyName()),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCurrencyDialog(l10n),
        ),
        
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          subtitle: Text(_getLanguageName(l10n)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(l10n),
        ),
      ],
    );
  }

  Widget _buildDataSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Data & Backup',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        const ListTile(
          leading: Icon(Icons.cloud_upload_outlined),
          title: Text('Cloud Sync'),
          subtitle: Text('Data automatically synced'),
          trailing: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            l10n.security,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: Text(l10n.changePassword),
          subtitle: const Text('Update your account password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _changePassword(l10n),
        ),
        
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(l10n.signOut),
          subtitle: const Text('End current session'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _signOut(l10n),
        ),
        
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: Text(l10n.deleteAccount),
          subtitle: Text('Permanently delete account and all data'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _deleteAccount(l10n),
        ),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'About',
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
          applicationLegalese: '© 2025 FinMate. All rights reserved.',
          aboutBoxChildren: [
            Text('FinMate - your personal finance management assistant.'),
            SizedBox(height: 8),
            Text('Track expenses, plan budgets and achieve financial goals.'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  String _getThemeName(AppLocalizations l10n) {
    switch (_settingsService.themeMode) {
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkThemeOption;
      case ThemeMode.system:
        return l10n.systemTheme;
    }
  }

  String _getLanguageName(AppLocalizations l10n) {
    switch (_settingsService.locale.languageCode) {
      case 'uk':
        return l10n.ukrainian;
      case 'en':
        return l10n.english;
      default:
        return l10n.ukrainian;
    }
  }

  Future<void> _showEditProfileDialog(AppLocalizations l10n) async {
    final nameController = TextEditingController(text: _authService.currentUser?.displayName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.fullName,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _authService.updateProfile(name: nameController.text);
                Navigator.of(context).pop();
                _showSnackBar('Profile updated');
                setState(() {});
              } catch (e) {
                _showSnackBar('Error updating profile: $e');
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemTheme),
              value: ThemeMode.system,
              groupValue: _settingsService.themeMode,
              onChanged: (value) async {
                await _settingsService.setThemeMode(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightTheme),
              value: ThemeMode.light,
              groupValue: _settingsService.themeMode,
              onChanged: (value) async {
                await _settingsService.setThemeMode(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkThemeOption),
              value: ThemeMode.dark,
              groupValue: _settingsService.themeMode,
              onChanged: (value) async {
                await _settingsService.setThemeMode(value!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.ukrainianHryvnia),
              value: 'UAH',
              groupValue: _settingsService.currency,
              onChanged: (value) async {
                await _settingsService.setCurrency(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.usDollar),
              value: 'USD',
              groupValue: _settingsService.currency,
              onChanged: (value) async {
                await _settingsService.setCurrency(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.euro),
              value: 'EUR',
              groupValue: _settingsService.currency,
              onChanged: (value) async {
                await _settingsService.setCurrency(value!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.ukrainian),
              value: 'uk',
              groupValue: _settingsService.locale.languageCode,
              onChanged: (value) async {
                await _settingsService.setLocale(Locale(value!));
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: _settingsService.locale.languageCode,
              onChanged: (value) async {
                await _settingsService.setLocale(Locale(value!));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(AppLocalizations l10n) async {
    final emailController = TextEditingController(text: _authService.currentUser?.email);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const Text('A password reset email will be sent to your email.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(emailController.text);
                Navigator.of(context).pop();
                _showSnackBar('Password reset email sent');
              } catch (e) {
                _showSnackBar('Error: $e');
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(AppLocalizations l10n) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOut),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                _dataService.clearData();
                await _authService.signOut();
              } catch (e) {
                _showSnackBar('Sign out error: $e');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(AppLocalizations l10n) async {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'WARNING! This will permanently delete your account and all data. This action cannot be undone.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Confirm with password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                await _authService.reauthenticate(passwordController.text);
                await _authService.deleteAccount();
                _showSnackBar('Account deleted');
              } catch (e) {
                _showSnackBar('Deletion error: $e');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}