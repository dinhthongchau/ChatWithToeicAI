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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    //Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120, // Tăng khoảng trống để chứa cả hai icon
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ChatHistoryScreen.route),
              icon: Icon(Icons.history),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => context.read<ChatProvider>().startNewSession(),
            ),
          ],
        ),
        title: Text(
          'Chat with TOEIC AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, 
          actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/avatar/logo.png'),
            ),
          ),
        ],
        ),
      body: Stack(
        children: [
          Body(controller: _controller, scrollController: _scrollController),
          Positioned(
            bottom: 95,
            right: 20,
            child: SizedBox(
              width: 30,
              height: 30,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 69, 67, 67),
                mini: true,
                onPressed: _scrollToBottom,
                child: Icon(Icons.expand_more, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required TextEditingController controller,
    required ScrollController scrollController,
  })  : _controller = controller,
        _scrollController = scrollController;

  final TextEditingController _controller;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    void _sendMessage() {
      final message = _controller.text;
      if (message.isNotEmpty) {
        context.read<ChatProvider>().addMessage(message);
        _controller.clear();
        Future.delayed(Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }

    return Column(
      children: [
        Expanded(
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(25),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = index.isEven;
                  return Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? const Color.fromARGB(255, 218, 236, 219)
                              : const Color.fromARGB(255, 136, 131, 131),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isUserMessage ? 16 : 2),
                            topRight: Radius.circular(isUserMessage ? 2 : 16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          chatProvider.messages[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: isUserMessage ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, size: 20),
                        tooltip: 'Sao chép tin nhắn',
                        onPressed: () {
                          context.read<ChatProvider>().copyMessage(chatProvider.messages[index]);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 69, 67, 67),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color.fromARGB(255, 145, 142, 142), width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Ask anything you want about TOEIC!!!',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return chatProvider.loadStatus == LoadStatus.Loading
                      ? Center(child: CircularProgressIndicator())
                      : IconButton(
                          icon: Icon(Icons.send, color: Colors.white, ),
                          onPressed: _sendMessage,
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
