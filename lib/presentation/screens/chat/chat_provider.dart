import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatModel;

  ChatProvider(this._chatModel);

  //init
  List<String> _messages = [];
  final List<String> _chatHistory =
      Hive.box('chatHistory').get('history', defaultValue: <String>[]) ?? [];

  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.init;

  //get
  LoadStatus get loadStatus => _loadStatus;

  List<String> get messages => _messages;

  String? get currentSessionId => _currentSessionId;

  List<String> get chatHistory => _chatHistory;

  //store chat current to Hive ( key,value is history: sessionId[], each sessionId: message[] )
  void saveCurrentSession(String sessionId) {
    Hive.box('chatHistory').put(sessionId, _messages);
    if (!_chatHistory.contains(sessionId)) {
      _chatHistory.add(sessionId);
      Hive.box('chatHistory').put('history', _chatHistory);
    }
    notifyListeners();
  }

  //load a chat in history
  void loadSession(String sessionId) {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = sessionId;
    _messages =
        Hive.box('chatHistory').get(sessionId, defaultValue: <String>[]);
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

  //add message with call api on current chat
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

  void renameChatSession(String oldSessionId, String newSessionId) {
    if (_chatHistory.contains(newSessionId)) {
      return;
    }

    final sessionMessages = Hive.box('chatHistory').get(oldSessionId);

    Hive.box('chatHistory').delete(oldSessionId);
    _chatHistory.remove(oldSessionId);

    Hive.box('chatHistory').put(newSessionId, sessionMessages);
    _chatHistory.add(newSessionId);
    Hive.box('chatHistory').put('history', _chatHistory);
    if (_currentSessionId == oldSessionId) {
      _currentSessionId = newSessionId;
    }

    notifyListeners();
  }

  void deleteChatSession(String sessionId) {
    Hive.box('chatHistory').delete(sessionId);
    _chatHistory.remove(sessionId);
    Hive.box('chatHistory').put('history', _chatHistory);
    notifyListeners();
  }

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
}
