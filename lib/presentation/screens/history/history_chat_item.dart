import 'package:flutter/material.dart';
import '../../../provider/chat_provider.dart';
import '../../../provider/theme_provider.dart';

class ChatHistoryItem extends StatelessWidget {
  final String sessionId;
  final bool isSelected;
  final ChatProvider chatProvider;
  final ThemeProvider themeProvider;
  final bool isLandscape;

  const ChatHistoryItem({
    super.key,
    required this.sessionId,
    required this.isSelected,
    required this.chatProvider,
    required this.themeProvider,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: themeProvider.ChatbotColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? (themeProvider.isLightTheme == false ? Colors.white : Colors.black)
              : themeProvider.historyBorderColor,
          width: 3.0,
        ),
      ),
      child: ListTile(
        title: Text(
          sessionId,
          style: TextStyle(color: themeProvider.textColor),
        ),
        onTap: () {
          chatProvider.loadSession(sessionId);
          if (!isLandscape) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}