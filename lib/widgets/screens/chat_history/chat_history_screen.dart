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
        title: Text("History Chat"),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      bottomNavigationBar: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SettingScreen.route);
          },
          icon: Icon(Icons.settings)),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  // Hàm hiển thị dialog khi nhấn lâu
  void _showOptionsDialog(BuildContext context, String sessionId) {
    final TextEditingController _renameController =
        TextEditingController(text: sessionId); // Khởi tạo với tên hiện tại

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
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
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
                      color: Colors.green,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        onLongPress: () =>
                            _showOptionsDialog(context, sessionId),
                        child: ListTile(
                          title: Text(chatProvider.chatHistory[index]),
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
