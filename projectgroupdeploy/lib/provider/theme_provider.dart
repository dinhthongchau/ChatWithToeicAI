import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isLightTheme = false;
  static const String _themeKey = 'isLightTheme';

  bool get isLightTheme => _isLightTheme;
  //load theme when open phone
  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
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


  // Background color
  Color get backgroundColor => _isLightTheme
      ? const Color.fromARGB(255, 245, 247, 250) //Light gray-blue
      : const Color.fromARGB(255, 26, 37, 38); //Deep blue-gray

  // Text color
  Color get textColor => _isLightTheme
      ? const Color.fromARGB(255, 26, 37, 38) //Dark blue-gray
      : const Color.fromARGB(255, 255, 255, 255); //White

  // History border color
  Color get historyBorderColor => _isLightTheme
      ? const Color.fromARGB(255, 224, 231, 255) //Light indigo
      : const Color.fromARGB(
          255, 42, 58, 59); //Slightly lighter blue-gray

  // Chatbot message background color
  Color get ChatbotColor => _isLightTheme
      ? const Color.fromARGB(255, 224, 247, 250) //Very light blue
      : const Color.fromARGB(255, 42, 58, 59); //Darker blue-gray

  // User message background color
  Color get userMessageColor => _isLightTheme
      ? const Color.fromARGB(255, 129, 212, 250) //Light blue
      : const Color.fromARGB(
          255, 79, 195, 247); //Slightly brighter blue

  // Bot message background color
  Color get botMessageColor => _isLightTheme
      ? const Color.fromARGB(255, 179, 229, 252) //Pastel blue
      : const Color.fromARGB(255, 42, 58, 59); //Darker blue

  // Input box background color
  Color get inputBoxColor => _isLightTheme
      ? const Color.fromARGB(255, 225, 245, 254) //Very light blue
      : const Color.fromARGB(255, 42, 58, 59); //Dark blue-gray

  // Input border color
  Color get inputBorderColor => _isLightTheme
      ? const Color.fromARGB(255, 79, 195, 247) //Medium blue
      : const Color.fromARGB(255, 79, 195, 247); //Same medium blue

  // Login button color
  Color get loginButtonBorderColor => _isLightTheme
      ? const Color.fromARGB(255, 2, 136, 209) //Medium blue
      : const Color.fromARGB(
          255, 79, 195, 247); //Slightly brighter blue

  // Register button color
  Color get registerButtonBorderColor => _isLightTheme
      ? const Color.fromARGB(255, 2, 136, 209) //Medium blue
      : const Color.fromARGB(
          255, 79, 195, 247); //Slightly brighter blue
}
