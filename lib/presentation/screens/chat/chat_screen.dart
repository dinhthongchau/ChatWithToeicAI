import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/history/history_screen.dart';
import 'package:ct312hm01_temp/provider/speech_to_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/history_visibility_provider.dart';
import '../../common_widgets/custom_loading_indicator.dart';
import '../../../provider/chat_provider.dart';
import '../../../provider/theme_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common_widgets/custom_notice_snackbar.dart';
import 'chat_message_item.dart';

class ChatScreen extends StatefulWidget {
  static const String route = "/chat";
  final int? userId;

  const ChatScreen({super.key, this.userId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider chatProvider = context.read<ChatProvider>();

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userId != null && chatProvider.userId != widget.userId) {
        chatProvider.setUserId(widget.userId!, ""); // User thường
      } else if (widget.userId == null && chatProvider.userId != -1) {
        chatProvider.setUserId(-1, null); // Guest user
      }

      chatProvider.initScroll(_scrollController);
      chatProvider.loadMessages();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        return Consumer<HistoryVisibilityProvider>(
          builder: (context, historyProvider, child) {
            return isLandscape
                ? Row(
                    children: [
                      if (historyProvider.isHistoryVisible)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: ChatHistoryScreen(),
                        ),
                      Expanded(
                        child: ChatScreenPage(
                          chatProvider: chatProvider,
                          inputController: _inputController,
                          scrollController: _scrollController,
                        ),
                      ),
                    ],
                  )
                : ChatScreenPage(
                    chatProvider: chatProvider,
                    inputController: _inputController,
                    scrollController: _scrollController,
                  );
          },
        );
      },
    );
  }
}

class ChatScreenPage extends StatelessWidget {
  const ChatScreenPage({
    super.key,
    required this.chatProvider,
    required TextEditingController inputController,
    required ScrollController scrollController,
  })  : _inputController = inputController,
        _scrollController = scrollController;

  final ChatProvider chatProvider;
  final TextEditingController _inputController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Page(
        chatProvider: chatProvider,
        inputController: _inputController,
        scrollController: _scrollController);
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.chatProvider,
    required TextEditingController inputController,
    required ScrollController scrollController,
  })  : _inputController = inputController,
        _scrollController = scrollController;

  final ChatProvider chatProvider;
  final TextEditingController _inputController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        //call when initialize

        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: buildAppBar(themeProvider, context),
          body: buildStack(themeProvider),
        );
      },
    );
  }

  AppBar buildAppBar(ThemeProvider themeProvider, BuildContext context) {
    return AppBar(
      backgroundColor: themeProvider.ChatbotColor,
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
        context.read<ChatProvider>().userId != -1
            ? IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: themeProvider.textColor,
                  size: 35,
                ),
                onPressed: () {
                  chatProvider.startNewSession();
                  Fluttertoast.showToast(
                    msg: "New chat created",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    //Flutter web không hổ trợ căn giữa cho Fluttertoast, nó sẽ hiển thị ở góc phải trên màn hình
                    backgroundColor: Colors.black,
                    //cũng không hổ trợ chỉnh màu nền ở web, còn chạy emulator android ios thì bình thường
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                })
            : Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(LoginScreen.route);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: themeProvider.inputBorderColor,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Stack buildStack(ThemeProvider themeProvider) {
    return Stack(
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
    void sendMessage() {
      final message = _inputController.text;
      if (message.isNotEmpty) {
        context.read<ChatProvider>().addMessage(message);
        _inputController.clear(); // Xóa nội dung ngay sau khi gửi
        context.read<SpeechToTextProvider>().stopListening();
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

              return ChatMessageList(
                chatProvider: chatProvider,
                themeProvider: themeProvider,
                scrollController: _scrollController,
              );
            },
          ),
        ),
        buildContainerChatInputBox(context, sendMessage),
      ],
    );
  }

  Container buildContainerChatInputBox(BuildContext context, void Function() sendMessage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().inputBoxColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.watch<ThemeProvider>().inputBorderColor,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          buildInputController(context),
          buildRecordButton(),
          buildSendButton(sendMessage),
        ],
      ),
    );
  }

  Expanded buildInputController(BuildContext context) {
    return Expanded(
          child: TextField(
            controller: _inputController,
            style: TextStyle(color: context.watch<ThemeProvider>().textColor),
            decoration: InputDecoration(
              hintText: 'Ask anything you want about TOEIC!!!',
              hintStyle: TextStyle(
                color: context
                    .watch<ThemeProvider>()
                    .textColor
                    .withAlpha((0.6 * 255).toInt()),
              ),
              border: InputBorder.none,
            ),
          ),
        );
  }

  Consumer<SpeechToTextProvider> buildRecordButton() {
    return Consumer<SpeechToTextProvider>(
          builder: (context, speechProvider, child) {
            return speechProvider.isListening
                ? IconButton(
              icon: Icon(Icons.stop,
                  color: context.watch<ThemeProvider>().textColor),
              onPressed: speechProvider.stopListening,
            )
                : IconButton(
              icon: Icon(Icons.mic,
                  color: context.watch<ThemeProvider>().textColor),
              onPressed: speechProvider.hasSpeech
                  ? () {
                _inputController.clear();
                speechProvider.startListening(_inputController);}
                  : null,
            );
          },
        );
  }

  Consumer<ChatProvider> buildSendButton(void Function() sendMessage) {
    return Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return chatProvider.loadStatus == LoadStatus.loading
                ? const Center(
              child: CustomLoadingIndicator(
                color: Colors.red,
                size: 30.0,
              ),
            )
                : IconButton(
              icon: Icon(Icons.send,
                  color: context.watch<ThemeProvider>().textColor),
              onPressed: () {
                if (_inputController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customNoticeSnackbar(
                        context, "Please ask question", true),
                  );
                } else {
                  sendMessage();
                  _inputController.clear();
                  context.read<SpeechToTextProvider>().stopListening();
                }
              },
            );
          },
        );
  }


}
