import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Dark theme'),
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (_) {},
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.attach_email_outlined),
          title: const Text('Export CSV'),
          onTap: () {},
        ),
        AboutListTile(
          icon: const Icon(Icons.info_outline),
          applicationName: 'FinMate',
          applicationVersion: '1.0.0',
        ),
      ],
    );
  }
}
