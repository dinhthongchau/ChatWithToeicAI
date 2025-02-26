import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';

class ReadingScreen extends StatelessWidget {
  static const String route = "/grammar";
  const ReadingScreen({super.key});

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
          Text("This is how to use app - -reading "),

        ],
      ),
    );
  }
}
