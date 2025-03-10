import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatProvider(this._chatModel);

  //init
  List<String> _messages = [];
  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.init;
  String? get _userId => _auth.currentUser?.uid;

  List<String> get chatHistory {
    if (_userId == null) return [];
    return Hive.box('chatHistory')
            .get('history_$_userId', defaultValue: <String>[]) ??
        [];
  }

  LoadStatus get loadStatus => _loadStatus;
  List<String> get messages => _messages;
  String? get currentSessionId => _currentSessionId;

  // Save chat history for each user
  void saveCurrentSession(String sessionId) {
    if (_userId == null) return;

    final box = Hive.box('chatHistory');
    box.put('$_userId-$sessionId', _messages);

    List<String> userHistory =
        box.get('history_$_userId', defaultValue: <String>[]);
    if (!userHistory.contains(sessionId)) {
      userHistory.add(sessionId);
      box.put('history_$_userId', userHistory);
    }

    notifyListeners();
  }

  // Load chat history by sessionId
  void loadSession(String sessionId) {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = sessionId;
    _messages = Hive.box('chatHistory')
        .get('$_userId-$sessionId', defaultValue: <String>[]);
    notifyListeners();
  }

  //start new chat
  void startNewSession() {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }

    _messages = [];
    _currentSessionId = 'Chat ${DateTime.now()}';
    notifyListeners();
  }

  // Send message and call API to get response
  Future<void> addMessage(String message) async {
    if (_currentSessionId == null) {
      startNewSession();
    }
    _messages.add(message);
    notifyListeners();
    _loadStatus = LoadStatus.loading;
    try {
      final response = await _chatModel.generateResponse(message);
      if (response != null) {
        _messages.add(response);
        notifyListeners();
        _loadStatus = LoadStatus.done;
      }
    } catch (e) {
      _loadStatus = LoadStatus.error;
    }
  }

  //copy selected message
  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    notifyListeners();
  }

  // rename session chat
  void renameChatSession(String oldSessionId, String newSessionId) {
    if (_userId == null || chatHistory.contains(newSessionId)) {
      return;
    }

    final sessionMessages =
        Hive.box('chatHistory').get('$_userId-$oldSessionId');

    Hive.box('chatHistory').delete('$_userId-$oldSessionId');
    List<String> userHistory = chatHistory;
    userHistory.remove(oldSessionId);

    Hive.box('chatHistory').put('$_userId-$newSessionId', sessionMessages);
    userHistory.add(newSessionId);

    Hive.box('chatHistory').put('history_$_userId', userHistory);
    if (_currentSessionId == oldSessionId) {
      _currentSessionId = newSessionId;
    }

    notifyListeners();
  }

  // Delete session chat
  void deleteChatSession(String sessionId) {
    if (_userId == null) return;
    Hive.box('chatHistory').delete('$_userId-$sessionId');
    List<String> userHistory = chatHistory;
    userHistory.remove(sessionId);
    Hive.box('chatHistory').put('history_$_userId', userHistory);
    notifyListeners();
  }

  // Scroll to bottom
  void scrollToBottom(ScrollController scrollController) {
    if (!scrollController.hasClients) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void initScroll(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(scrollController);
    });
  }

  void loadMessages() {
    if (_userId == null) return;

    final box = Hive.box('chatHistory');
    _messages = List<String>.from(
        box.get('$_userId-$_currentSessionId', defaultValue: []));

    notifyListeners();
  }

  void debugHiveData() {
    final box = Hive.box('chatHistory');
    print("Saved sessions: ${box.get('history_$_userId')}");
    print(
        "Messages for session $_currentSessionId: ${box.get('$_userId-$_currentSessionId')}");
  }

  void resetChat() {
    _messages.clear();
    notifyListeners();
  }
}
