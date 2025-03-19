import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
   bool _isLightTheme = false;
   static const String _themeKey = 'isLightTheme';

   bool get isLightTheme => _isLightTheme;
   //load theme when open phone
   ThemeProvider(){
     _loadTheme();
   }

   Future<void> _loadTheme () async {
     final prefs = await SharedPreferences.getInstance();
     _isLightTheme = prefs.getBool(_themeKey) ?? false;
     notifyListeners();
   }
   Future<void> setTheme(bool isLightTheme) async {
     _isLightTheme = isLightTheme;

     final prefs = await SharedPreferences.getInstance();
     await prefs.setBool(_themeKey, isLightTheme);
     notifyListeners();
   }

  Color get backgroundColor => _isLightTheme ? Colors.white : Colors.black; // màu nền
  Color get textColor => _isLightTheme ? Colors.black : Colors.white; // màu chữ
   Color get historyBorderColor => _isLightTheme //
       ? Colors.white
       : Colors.black;
  Color get ChatbotColor => _isLightTheme //
      ? Color.fromARGB(255, 240, 240, 240)
      : Color.fromARGB(255, 69, 67, 67);
  Color get userMessageColor => _isLightTheme //màu nền tin nhắn User
      ? Color.fromARGB(255, 200, 230, 201)
      : Color.fromARGB(255, 129, 224, 133);
  Color get botMessageColor => _isLightTheme // màu nền tin nhắn Bot
      ? Color.fromARGB(255, 210, 210, 210)
      : Color.fromARGB(255, 136, 131, 131);

  Color get inputBoxColor => _isLightTheme // màu nền khung nhập 
      ? Color.fromARGB(255, 240, 240, 240) 
      : Color.fromARGB(255, 69, 67, 67); 

  Color get inputBorderColor => _isLightTheme //màu viền khung nhập
      ? Color.fromARGB(255, 180, 180, 180) 
      : Color.fromARGB(255, 145, 142, 142); 
  Color get loginButtonBorderColor => _isLightTheme //màu viền khung nhập
      ? Color.fromARGB(255, 124, 206, 173)
      : Colors.green;
   Color get registerButtonBorderColor => _isLightTheme //màu viền khung nhập
       ? Color.fromARGB(255, 124, 206, 173)
       : Colors.grey;
}
