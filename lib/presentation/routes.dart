import 'package:ct312hm01_temp/presentation/screens/history/history_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/guide/guide_screen.dart';
import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat/chat_screen.dart';


Route<dynamic> mainRoute(RouteSettings settings) {
  return switch (settings.name) {
    ChatScreen.route => MaterialPageRoute(builder: (context) => ChatScreen()),
    ChatHistoryScreen.route => MaterialPageRoute(builder: (context) => ChatHistoryScreen()),
    GuideScreen.route => MaterialPageRoute(builder: (context) => GuideScreen()),
    LoginScreen.route => MaterialPageRoute(builder: (context) => LoginScreen()),
    RegisterScreen.route => MaterialPageRoute(builder: (context) => RegisterScreen()),
    _ => MaterialPageRoute(builder: (context) => ChatScreen())
  };

}