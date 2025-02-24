import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:ct312hm01_temp/widgets/screens/chat/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'widgets/screens/chat/chat_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String apiKey = 'AIzaSyA6eb5jge_GI5NS29exFS7mfZj4RHrcAsY';
    final chatModel = ChatModel(apiKey);
    return ChangeNotifierProvider(
      create: (_) =>ChatProvider(chatModel),
      child: MaterialApp(
        title: 'Chat with TOEIC AI',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: mainRoute,
        initialRoute: ChatScreen.route,
      ),
    );
  }
}