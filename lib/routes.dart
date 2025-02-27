import 'package:ct312hm01_temp/widgets/screens/chat_history/chat_history_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/screens/chat/chat_screen.dart';


Route<dynamic> mainRoute(RouteSettings settings) {
  switch (settings.name) {
    case ChatScreen.route:
      return MaterialPageRoute(builder: (context) => ChatScreen());
    case ChatHistoryScreen.route:
      return MaterialPageRoute(builder: (context) => ChatHistoryScreen());
    case SettingScreen.route:
      return MaterialPageRoute(builder: (context) => SettingScreen());
    case GuideScreen.route:
      return MaterialPageRoute(builder: (context) => GuideScreen());
    default:
      return MaterialPageRoute(builder: (context) => ChatScreen());
  }

}