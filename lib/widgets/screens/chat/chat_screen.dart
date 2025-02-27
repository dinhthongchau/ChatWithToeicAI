import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/widgets/screens/chat_history/chat_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class ChatScreen extends StatefulWidget {
  static const String route = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty) {
      context.read<ChatProvider>().addMessage(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          leading: IconButton( onPressed: ()=> Navigator.of(context).pushNamed(ChatHistoryScreen.route),icon:  Icon(Icons.history)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Chat with TOEIC AI'),
              IconButton(icon: Icon(Icons.add),onPressed: ()=> {
                context.read<ChatProvider>().startNewSession()
              })
            ],
          ),

      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return chatProvider.loadStatus == LoadStatus.Loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.all(25),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          bool isUserMessage = index.isEven;
                          return Container(
                            color: isUserMessage ? Colors.green : Colors.grey,
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.center,
                            child: Text(
                              chatProvider.messages[index],
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Type a message'),
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
