import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await credential.user?.updateDisplayName(name);
      
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _getAuthError(e.code);
    } catch (e) {
      throw 'Сталася помилка при реєстрації';
    }
  }

  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _getAuthError(e.code);
    } catch (e) {
      throw 'Сталася помилка при вході';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'Помилка при виході з акаунта';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getAuthError(e.code);
    } catch (e) {
      throw 'Помилка при скиданні пароля';
    }
  }
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      final user = currentUser;
      if (user != null) {
        if (name != null) await user.updateDisplayName(name);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
        notifyListeners();
      }
    } catch (e) {
      throw 'Помилка при оновленні профілю';
    }
  }

  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      notifyListeners();
    } catch (e) {
      throw 'Помилка при видаленні акаунта';
    }
  }

  Future<void> reauthenticate(String password) async {
    try {
      final user = currentUser;
      if (user?.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw _getAuthError(e.code);
    } catch (e) {
      throw 'Помилка при повторній аутентифікації';
    }
  }

  String _getAuthError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Пароль занадто слабкий';
      case 'email-already-in-use':
        return 'Цей email вже використовується';
      case 'invalid-email':
        return 'Некоректний email';
      case 'user-disabled':
        return 'Акаунт заблоковано';
      case 'user-not-found':
        return 'Користувача не знайдено';
      case 'wrong-password':
        return 'Неправильний пароль';
      case 'too-many-requests':
        return 'Занадто багато спроб. Спробуйте пізніше';
      case 'network-request-failed':
        return 'Помилка мережі. Перевірте підключення до інтернету';
      case 'requires-recent-login':
        return 'Потрібна повторна аутентифікація';
      default:
        return 'Сталася помилка аутентифікації';
    }
  }
}