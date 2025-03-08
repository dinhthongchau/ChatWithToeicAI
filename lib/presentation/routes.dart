import 'package:ct312hm01_temp/presentation/screens/history/history_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/guide/guide_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> mainRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case ChatScreen.route:
      page = ChatScreen();
      break;
    case ChatHistoryScreen.route:
      page = ChatHistoryScreen();
      break;
    case GuideScreen.route:
      page = GuideScreen();
      break;
    case LoginScreen.route:
      page = LoginScreen();
      break;
    case RegisterScreen.route:
      page = RegisterScreen();
      break;
    default:
      page = ChatScreen();
  }

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}