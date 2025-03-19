import 'package:flutter/material.dart';

class HistoryVisibilityProvider with ChangeNotifier {
  bool _isHistoryVisible = true;

  bool get isHistoryVisible => _isHistoryVisible;

  void toggleVisibility() {
    _isHistoryVisible = !_isHistoryVisible;
    notifyListeners();
  }

  void showHistory() {
    _isHistoryVisible = true;
    notifyListeners();
  }

  void hideHistory() {
    _isHistoryVisible = false;
    notifyListeners();
  }
}