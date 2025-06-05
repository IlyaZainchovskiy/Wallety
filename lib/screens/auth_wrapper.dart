import 'package:finance_app/l10n/app_localizations.dart';
import 'package:finance_app/main.dart';
import 'package:finance_app/screens/welcome.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/firebase_data.service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder(
            future: FirebaseDataService().initializeUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                final l10n = AppLocalizations.of(context);
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l10n?.loadingData ?? 'Loading data...',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }              
              return const HomePage();
            },
          );
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}