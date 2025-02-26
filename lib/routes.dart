import 'package:ct312hm01_temp/widgets/screens/chat_history/chat_history_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/screens/chat/chat_screen.dart';
import 'widgets/screens/guide/grammar_screen.dart';
import 'widgets/screens/guide/listening_screen.dart';
import 'widgets/screens/guide/reading_screen.dart';
import 'widgets/screens/guide/strategy_screen.dart';
import 'widgets/screens/guide/vobcabulary_screen.dart';

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
    case VobcabularyScreen.route:
      return MaterialPageRoute(builder: (context) => VobcabularyScreen());
    case ReadingScreen.route:
      return MaterialPageRoute(builder: (context) => ReadingScreen());
    case ListeningScreen.route:
      return MaterialPageRoute(builder: (context) => ListeningScreen());
    case GrammarScreen.route:
      return MaterialPageRoute(builder: (context) => GrammarScreen());
    case StrategyScreen.route:
      return MaterialPageRoute(builder: (context) => StrategyScreen());
    default:
      return MaterialPageRoute(builder: (context) => ChatScreen());
  }

}