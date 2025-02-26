import 'package:ct312hm01_temp/common/enum/drawer_item.dart';
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
}