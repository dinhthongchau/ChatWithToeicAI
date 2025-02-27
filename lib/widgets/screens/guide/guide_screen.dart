
import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';


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

          Text("Hoc ntn"),

        ],
      ),
    );
  }
}
