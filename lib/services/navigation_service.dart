import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  Function(int)? _navigateToTab;
  
  void setNavigationCallback(Function(int) callback) {
    _navigateToTab = callback;
  }
  
  void navigateToTab(int tabIndex) {
    if (_navigateToTab != null) {
      _navigateToTab!(tabIndex);
    }
  }
  
  void clearNavigationCallback() {
    _navigateToTab = null;
  }
}