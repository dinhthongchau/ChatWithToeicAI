// widgets/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import '../../../models/chat_model.dart';


class ChatScreen extends StatefulWidget {
  static const String route = "/chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatModel chatModel = ChatModel('AIzaSyA6eb5jge_GI5NS29exFS7mfZj4RHrcAsY');
  String _response = '';

  void _sendMessage() async {
    String input = _controller.text;
    String? response = await chatModel.generateResponse(input);
    setState(() {
      _response = response!;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with TOEIC AI')),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Text(_response))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type your message here...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}