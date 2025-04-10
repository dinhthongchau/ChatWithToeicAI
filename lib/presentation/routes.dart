import 'package:ct312hm01_temp/presentation/screens/history/history_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/register_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';


Route<dynamic> mainRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/chat':
      final userId = settings.arguments as int?;
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatScreen(userId: userId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Right to left
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );

    case '/chatHistory': // Replace with your actual route names
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatHistoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // Left to right
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );

    case '/guide':
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => GuideScreen(),
      );

    case '/login':
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            // Circular reveal isn't natively simple, so using fade as a substitute
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );

    case '/register':
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => RegisterScreen(),
      );

    default:
    // Fallback route for undefined paths
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const Scaffold(
          body: Center(child: Text('Page not found')),
        ),
      );
  }
}