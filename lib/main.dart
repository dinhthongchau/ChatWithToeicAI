import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:ct312hm01_temp/widgets/screens/chat/chat_provider.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'widgets/screens/chat/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('chatHistory');
  await dotenv.load(fileName: "lib/dotenv");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String? apiKey= dotenv.env['API_KEY'];
    final chatModel = ChatModel(apiKey!);
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