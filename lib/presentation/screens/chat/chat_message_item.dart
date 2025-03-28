import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/enum/load_tts_status.dart';
import '../../../provider/chat_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../provider/text_to_speech_provider.dart';

class ChatMessageList extends StatelessWidget {
  final ChatProvider chatProvider;
  final ThemeProvider themeProvider;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.chatProvider,
    required this.themeProvider,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(25),
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        bool isUserMessage = index.isEven;
        return Column(
          crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? themeProvider.userMessageColor
                    : themeProvider.botMessageColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUserMessage ? 16 : 2),
                  topRight: Radius.circular(isUserMessage ? 2 : 16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: MarkdownBody(
                data: chatProvider.messages[index],
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 16,
                    color: themeProvider.textColor,
                  ),
                ),
              ),
            ),
            if (!isUserMessage)
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, size: 20, color: themeProvider.textColor),
                    tooltip: 'Sao chép tin nhắn',
                    onPressed: () {
                      context.read<ChatProvider>().copyMessage(chatProvider.messages[index]);
                    },
                  ),
                  context.watch<TextToSpeechProvider>().loadStatus == LoadStatusTts.isPlaying
                      ? IconButton(
                    icon: Icon(Icons.stop, size: 20, color: themeProvider.textColor),
                    onPressed: () {
                      context.read<TextToSpeechProvider>().stop();
                    },
                  )
                      : IconButton(
                    icon: Icon(Icons.volume_up, size: 20, color: themeProvider.textColor),
                    onPressed: () {
                      context.read<TextToSpeechProvider>().speak(chatProvider.messages[index]);
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}