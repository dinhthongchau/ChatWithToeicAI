import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/widgets/common_widgets/notice_snackbar.dart';
import 'package:ct312hm01_temp/widgets/screens/chat_history/chat_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';
import '../setting/theme_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  static const String route = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider chatProvider =
      context.read<ChatProvider>(); // Khai báo chatProvider

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>(); // Khởi tạo chatProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.initScroll(_scrollController);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Hủy ScrollController
    _inputController.dispose(); // Hủy TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        //call when initialize

        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.chatBoxColor,
            leadingWidth: 120,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ChatHistoryScreen.route),
                  icon: Icon(
                    Icons.format_list_bulleted,
                    color: themeProvider.textColor,
                    size: 35,
                  ),
                ),
              ],
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/avatar/logo.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'TOEIC AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.textColor,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: themeProvider.textColor,
                    size: 35,
                  ),
                  onPressed: () {
                    chatProvider.startNewSession();
                    Fluttertoast.showToast(
                      msg: "New chat",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      //Flutter web không hổ trợ căn giữa cho Fluttertoast, nó sẽ hiển thị ở góc phải trên màn hình
                      backgroundColor: Colors.black.withOpacity(0.8),
                      //cũng không hổ trợ chỉnh màu nền ở web, còn chạy emulator android ios thì bình thường
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }),
            ],
          ),
          body: Stack(
            children: [
              Body(
                controller: _inputController,
                // need controller for listview
                scrollController: _scrollController,
              ),
              Positioned(
                bottom: 95,
                right: 20,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    backgroundColor: themeProvider.botMessageColor,
                    mini: true,
                    onPressed: () {
                      chatProvider.scrollToBottom(_scrollController);
                    },
                    child: Icon(Icons.expand_more,
                        size: 25, color: themeProvider.textColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required TextEditingController controller,
    required ScrollController scrollController,
  })  : _inputController = controller,
        _scrollController = scrollController;

  final TextEditingController _inputController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    void _sendMessage() {
      final message = _inputController.text;
      if (message.isNotEmpty) {
        context.read<ChatProvider>().addMessage(message);
        _inputController.clear();
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
              final themeProvider =
                  context.watch<ThemeProvider>(); // Lấy theme hiện tại

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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
                        child: Text(
                          chatProvider.messages[index],
                          style: TextStyle(
                            fontSize: 18,
                            // color: isUserMessage
                            //     ? themeProvider
                            //         .textColor
                            //     : Colors.white,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy,
                            size: 20,
                            color: themeProvider
                                .textColor), // Đổi màu icon theo theme
                        tooltip: 'Sao chép tin nhắn',
                        onPressed: () {
                          context
                              .read<ChatProvider>()
                              .copyMessage(chatProvider.messages[index]);
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
            color: context
                .watch<ThemeProvider>()
                .inputBoxColor, // Màu nền theo theme
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context
                  .watch<ThemeProvider>()
                  .inputBorderColor, // Màu viền theo theme
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  style: TextStyle(
                      color: context
                          .watch<ThemeProvider>()
                          .textColor), // Màu chữ theo theme
                  decoration: InputDecoration(
                    hintText: 'Ask anything you want about TOEIC!!!',
                    hintStyle: TextStyle(
                        color: context
                            .watch<ThemeProvider>()
                            .textColor
                            .withOpacity(0.6)), // Màu gợi ý
                    border: InputBorder.none,
                  ),
                ),
              ),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {

                  return chatProvider.loadStatus == LoadStatus.Loading
                      ? Center(child: CircularProgressIndicator())
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: context
                                  .watch<ThemeProvider>()
                                  .textColor), // Màu icon theo theme
                          onPressed: () {
                            if ( _inputController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                noticeSnackbar(context,"Please ask question", true),
                              );
                            } else {
                              _sendMessage();
                            }
                          });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
