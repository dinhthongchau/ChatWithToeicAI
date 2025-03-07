import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/app_auth_provider.dart';
import '../chat/chat_provider.dart';
import '../setting/setting_dialog.dart';
import '../setting/theme_provider.dart';
import 'history_options_dialog.dart';

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

class CustomHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                  color: themeProvider.HistoryborderColor,
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
                  SizedBox(width: 10), // Khoảng cách giữa avatar và tên
                  // Tên người dùng
                  Text(
                    "${context.read<AppAuthProvider>().getEmailAfterSignIn()}" ,// Giá trị ví dụ
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
    return Consumer2<ChatProvider, ThemeProvider>(
      builder: (context, chatProvider, themeProvider, child) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Conservations"),
                  TextButton(
                      child: Row(
                        children: [
                          Text("New"),
                          Icon(Icons.add),
                        ],
                      ),
                      onPressed: () => {
                            context.read<ChatProvider>().startNewSession(),
                            Navigator.pop(context)
                          })
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatProvider.chatHistory.length,
                  itemBuilder: (context, index) {
                    final sessionId = chatProvider.chatHistory[index];
                    final isSelected =
                        sessionId == chatProvider.currentSessionId;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: themeProvider.chatBoxColor,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: Colors.white,
                                width: 2.0,
                              )
                            : Border.all(
                                //color: themeProvider.HistoryborderColor,

                                width: 2.0, // Độ dày của viền
                              ), // Chỉnh border radius
                      ),

                      child: GestureDetector(
                        onLongPress: () => showOptionsDialog(context, sessionId),
                        child: ListTile(
                          title: Text(
                            chatProvider.chatHistory[index],
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
