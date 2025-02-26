import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:ct312hm01_temp/widgets/screens/chat/chat_provider.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'widgets/screens/chat/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Khởi tạo Hive cho Flutter
  await Hive.openBox('chatHistory'); // Mở box lưu lịch sử chat

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String apiKey = 'AIzaSyA6eb5jge_GI5NS29exFS7mfZj4RHrcAsY';
    final chatModel = ChatModel(apiKey);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(chatModel),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Chat with TOEIC AI',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.isLightTheme ? ThemeMode.light : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: mainRoute,
            initialRoute: ChatScreen.route,
          );
        },

      ),
    );
  }
}