import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/chat_provider.dart';
import '../setting/setting_dialog.dart';
import '../../../provider/theme_provider.dart';
import 'history_options_dialog.dart';
import '../chat/chat_screen.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const String route = "/chatHistory";

  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Page();
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHistoryAppBar(),
      bottomNavigationBar: BottomNavigationBar(),
      body: Body(),
    );
  }
}


class CustomHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomHistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("History Chat"),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: themeProvider.chatBoxColor, // Màu theo theme
            border: Border(
              top: BorderSide(
                  color: themeProvider.historyBorderColor,
                  width: 0.5), // Màu viền
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar + Tên người dùng
              Row(
                children: [
                  // Avatar tròn
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        AssetImage('assets/avatar/logo.png'), // Đường dẫn ảnh
                    backgroundColor: themeProvider
                        .inputBorderColor, // Màu nền nếu không có ảnh
                  ),
                  SizedBox(width: 10),
                  Text(
                    context.read<ChatProvider>().userEmail??
                    "Guest",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.textColor, // Màu chữ theo theme
                    ),
                  ),
                ],
              ),

              // Nút Settings có sự kiện riêng
              IconButton(
                onPressed: () {
                  showSettingDialog(context);
                },
                icon: Icon(Icons.settings,
                    color: themeProvider.textColor), // Màu theo theme
              ),
            ],
          ),
        );
      },
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // drag right -> route to ChatScreen
          Navigator.pushReplacementNamed(context, ChatScreen.route);
        }
      },
      child: Consumer2<ChatProvider, ThemeProvider>(
          builder: (context, chatProvider, themeProvider, child) {

        final chatHistory = chatProvider.getChatHistory();
        print("Chat history data: $chatHistory");

        return Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            final chatHistory = chatProvider.chatHistory; // Dùng danh sách có sẵn, không gọi hàm mới

            if (chatHistory.isEmpty) {
              return const Center(child: Text("No chat history available."));
            }

            return ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final sessionId = chatHistory[index] ;
                final isSelected = sessionId == chatProvider.currentSessionId;
                return GestureDetector(
                  onLongPress: () {
                    showOptionsDialog(context, sessionId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: themeProvider.chatBoxColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.white : themeProvider.historyBorderColor,
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        sessionId,
                        style: TextStyle(color: themeProvider.textColor),
                      ),
                      onTap: () {
                        chatProvider.loadSession(sessionId);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
          },
        );

          }
      ),
    );
  }
}
