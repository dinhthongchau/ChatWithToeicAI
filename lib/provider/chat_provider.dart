// import 'package:ct312hm01_temp/core/enum/load_status.dart';
// import 'package:ct312hm01_temp/services/chat_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:ct312hm01_temp/database/chat_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatModel;
  final ChatDB _chatDatabase = ChatDB();

  ChatProvider(this._chatModel);

  //init
  List<String> _messages = [];
  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.init;
  // String? _userId;
  int? _userId;

  // List<String> get chatHistory =>
  //     _userId == null ? [] : ChatDB.getUserChatHistory(_userId!);
  List<String> _chatHistory = [];
  List<String> get chatHistory => _chatHistory;
  Future<void> loadChatHistory() async {
    if (_userId == null) {
      print("Nothing to load");
    };
    _chatHistory = await ChatDB.getUserChatHistory(_userId!);
    print("Loaded chat history in loadChatHistory: $_chatHistory");
    notifyListeners();
  }

  
  Future<List<String>> getChatHistory() async {
    if (_userId == null) return ["ok"];
    return await ChatDB.getUserChatHistory(_userId!);
  }


  LoadStatus get loadStatus => _loadStatus;
  List<String> get messages => _messages;
  String? get currentSessionId => _currentSessionId;

  void setUserId(int userId) {
    _userId = userId;
    print("User ID set: $_userId");
    loadChatHistory(); // Tải lịch sử chat ngay sau khi đặt userId
    notifyListeners();
  }

  // Save chat history for each user
  Future<void> saveCurrentSession(String sessionId) async {
    if (_userId == null) return;
    try {
      await ChatDB.saveChatSession(_userId!, sessionId, _messages);
      notifyListeners();
    }
   catch(e){
      print(e);
   }
  }

  // Load chat history by sessionId
  Future<void> loadSession(String sessionId) async {
    if (_userId == null) return;

    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = sessionId;
    _messages = await ChatDB.loadChatMessages(_userId!, sessionId);
    notifyListeners();
  }

  //start new chat
  Future<void> startNewSession() async {
    //save if it has messages
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }

    _messages = [];
    _currentSessionId = 'Chat ${DateTime.now()}';
    //create new chat in database
    if ( _userId != null){
      await ChatDB.createChatSession(_userId!);
      await loadChatHistory();
    }
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
        //dòng mới
        // await _chatDatabase.saveChatSession(
        //     _userId!, _currentSessionId!, _messages);
        await saveCurrentSession(_currentSessionId!);
        notifyListeners();
      }
      _loadStatus = LoadStatus.done;
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
  Future<void> renameChatSession(
      String oldSessionId, String newSessionId) async {
    if (_userId == null || oldSessionId == newSessionId) return;
    await ChatDB.renameChatSession(_userId!, oldSessionId, newSessionId);
    if (_currentSessionId == oldSessionId) {
      _currentSessionId = newSessionId;
    }
    notifyListeners();
  }

  // Delete session chat
  Future<void> deleteChatSession(String sessionId) async {
    if (_userId == null) return;
    await ChatDB.deleteChatSession(_userId!, sessionId);
    notifyListeners();
  }

  // Scroll to bottom
void scrollToBottom(ScrollController scrollController) {
    if (!scrollController.hasClients ||
        !scrollController.position.hasContentDimensions) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients ||
          !scrollController.position.hasContentDimensions) return;

      final maxScroll = scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) return;

      scrollController.animateTo(
        maxScroll,
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


  // Tải tin nhắn từ session hiện tại
  Future<void> loadMessages() async {
    if (_userId == null || _currentSessionId == null) return;
    _messages =
        await ChatDB.loadChatMessages(_userId!, _currentSessionId!);
    notifyListeners();
  }

  // Reset tin nhắn
  void resetChat() {
    _messages.clear();
    notifyListeners();
  }
}
