import 'package:ct312hm01_temp/widgets/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat/chat_provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const String route = "/chatHistory";

  const ChatHistoryScreen({super.key});

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
            Navigator.of(context).pushNamed(SettingScreen.route);
          }, icon: Icon(Icons.settings)),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return ListView.builder(
            itemCount: chatProvider.chatHistory.length,
            itemBuilder: (context, index) {
              final sessionId = chatProvider.chatHistory[index];
              return Container(
                color: Colors.green,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(chatProvider.chatHistory[index]),
                  onTap: () {
                    chatProvider.loadSession(sessionId);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
