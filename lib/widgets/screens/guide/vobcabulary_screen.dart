import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';

class VobcabularyScreen extends StatelessWidget {
  static const String route = "/vocabulary";
  const VobcabularyScreen({super.key});

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
          Text("🟢 Giải thích từ 'mitigate' và cho ví dụ cụ thể? So sánh nghĩa của 'affect' và 'effect' trong TOEIC? "),

        ],
      ),
    );
  }
}
