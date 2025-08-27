import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/history_screen.dart';
import '../screens/login.dart';
import '../screens/credits_screen.dart';

class AppRoutes {
  static const String homeScreen = '/home_screen';
  static const String historyScreen = '/history_screen';
  static const String loginScreen = '/login';
  static const String creditsScreen = '/credits';

  static final Map<String, WidgetBuilder> routes = {
    homeScreen: (context) => const HomeScreen(),
    historyScreen: (context) => const HistoryScreen(),
    loginScreen: (context) => const LoginScreen(),
    creditsScreen: (context) => const CreditsScreen(),
  };
}
