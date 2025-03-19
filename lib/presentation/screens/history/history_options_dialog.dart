import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat_provider.dart';

void showOptionsDialog(BuildContext context, String sessionId) {
  final TextEditingController renameController = TextEditingController(text: sessionId);

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
              controller: renameController,
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
              final newName = renameController.text.trim();
              if (newName.isNotEmpty && newName != sessionId) {
                context  .read<ChatProvider>().renameChatSession(sessionId, newName);
                //context  .read<ChatProvider>().renameChatSession("56", "566");
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