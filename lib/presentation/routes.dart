import 'package:flutter/material.dart';
import 'package:ct312hm01_temp/presentation/screens/history/history_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/register_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/chat/chat_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

final List<GetPage> routes = [
  GetPage(
      name: ChatScreen.route,
      page: () => ChatScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300)),
  GetPage(
    name: ChatHistoryScreen.route,
    page: () => ChatHistoryScreen(),
    transition: Transition.leftToRight,
    transitionDuration: Duration(milliseconds: 300),
  ),
  GetPage(
      name: GuideScreen.route,
      page: () => GuideScreen(),
  ),
  GetPage(
      name: LoginScreen.route,
      page: () => LoginScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 300)),
  GetPage(
      name: RegisterScreen.route,
      page: () => RegisterScreen(),

  ),
];
