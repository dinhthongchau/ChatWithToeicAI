import 'package:ct312hm01_temp/widgets/screens/guide/grammar_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/listening_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/reading_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/strategy_screen.dart';
import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';
import 'vobcabulary_screen.dart';

class GuideScreen extends StatelessWidget {
  static const String route = "/guide";
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      bottomNavigationBar:
      IconButton(onPressed: () {

        Navigator.of(context).pushNamed(ChatScreen.route);
      }, icon: Icon(Icons.home_outlined)),
      body: Column(
        children: [

          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(VobcabularyScreen.route);
          }, child: Text("TOi muon cach dung chat AI voi tu vung ")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(GrammarScreen.route);
          }, child: Text("TOi muon cach dung chat AI voi grammar ")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(ListeningScreen.route);
          }, child: Text("TOi muon cach dung chat AI voi tu ListeningScreen ")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(StrategyScreen.route);
          }, child: Text("TOi muon cach dung chat AI voi tu StrategyScreen ")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(ReadingScreen.route);
          }, child: Text("TOi muon cach dung chat AI voi tu ReadingScreen ")),

        ],
      ),
    );
  }
}
