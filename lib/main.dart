import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/chat/chat_provider.dart';
import 'package:ct312hm01_temp/presentation/screens/setting/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/routes.dart';
import 'presentation/screens/auth/app_auth_provider.dart';
Future<void> initializeApp() async {

}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // support by firebase_options.dart
  );
  //initial Hive
  await Hive.initFlutter();
  await Hive.openBox('chatHistory');
  //load .env
  await dotenv.load(fileName: "lib/dotenv");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    String? apiKey= dotenv.env['API_KEY'];
    final chatService = ChatService(apiKey!);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(chatService),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider (),
        ),


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
            initialRoute: FirebaseAuth.instance.currentUser== null ? LoginScreen.route : LoginScreen.route,
          );
        },

      ),
    );
  }
}