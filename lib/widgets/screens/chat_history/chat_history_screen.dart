import 'package:ct312hm01_temp/widgets/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/chat_provider.dart';
import '../setting/theme_provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const String route = "/chatHistory";

  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Chat"),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),

        bottomNavigationBar: Consumer<ThemeProvider>(
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
                      "Nguyễn Nhật A", // Giá trị ví dụ
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
                    Navigator.of(context).pushNamed(SettingScreen.route);
                  },
                  icon: Icon(Icons.settings,
                      color: themeProvider.textColor), // Màu theo theme
                ),
              ],
            ),
          );
        },
      ),

      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  void _showOptionsDialog(BuildContext context, String sessionId) {
    final TextEditingController _renameController =
        TextEditingController(text: sessionId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chat Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trường nhập liệu để đổi tên
              TextField(
                controller: _renameController,
                decoration: InputDecoration(
                  labelText: "New Session Name",
                  hintText: "Enter new name",
                ),
              ),
            ],
          ),
          actions: [
            // Nút đổi tên
            TextButton(
              onPressed: () {
                final newName = _renameController.text.trim();
                if (newName.isNotEmpty && newName != sessionId) {
                  context
                      .read<ChatProvider>()
                      .renameChatSession(sessionId, newName);
                }
                Navigator.pop(context); // Đóng dialog sau khi đổi tên
              },
              child: Row(
                children: [Text("Rename"), Icon(Icons.edit)],
              ),
            ),
            // Nút xóa
            TextButton(
              onPressed: () {
                context.read<ChatProvider>().deleteChatSession(sessionId);
                Navigator.pop(context); // Đóng dialog sau khi xóa
              },
              child: Row(
                children: [
                  Text("Delete", style: TextStyle(color: Colors.red)),
                  Icon(Icons.delete, color: Colors.red)
                ],
              ),
            ),
            // Nút hủy
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, ThemeProvider>(
      builder: (context, chatProvider,themeProvider, child) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Conservation"),
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
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: themeProvider.chatBoxColor,
                        borderRadius:
                            BorderRadius.circular(16),
                            border: Border.all(
                              color: themeProvider.HistoryborderColor, // Màu viền lấy từ ThemeProvider
                              width: 2.0, // Độ dày của viền
                        ), // Chỉnh border radius
                      ),
                      // padding: EdgeInsets.all(10),
                      // margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        onLongPress: () =>
                            _showOptionsDialog(context, sessionId),
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
