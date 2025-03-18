import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/provider/chat_provider.dart';
import 'package:ct312hm01_temp/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'presentation/routes.dart';
import 'provider/app_auth_provider.dart';
import 'data/database/db_helper.dart';
import 'data/models/user_model.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình databaseFactory cho Web
  databaseFactory = databaseFactoryFfiWeb;
  await DBHelper.database;

  // Load biến môi trường
  await dotenv.load(fileName: "lib/dotenv");
}

Future<void> main() async {
  await initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    // Giả sử bạn có một cơ chế lưu user đăng nhập gần nhất (có thể dùng SharedPreferences)
    // Ở đây tôi để tạm null -> Màn hình Login sẽ hiển thị
    setState(() {
      _currentUser = null;
    });
  }

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
            // Chuyển hướng: nếu user chưa đăng nhập -> LoginScreen
            initialRoute: _currentUser == null ? LoginScreen.route : LoginScreen.route,
          );
        },

      ),
    );
  }
}