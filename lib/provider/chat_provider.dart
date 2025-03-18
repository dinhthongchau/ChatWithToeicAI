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
  ChatProvider(this._chatModel);

  //init
  List<String> _messages = [];
  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.init;
  // String? _userId;
  int? _userId;
  String? _userEmail;

  int? get userId => _userId;
  String? get userEmail => _userEmail;
  final bool _isCreatingSession = false;
  bool get isCreatingSession => _isCreatingSession;


  List<String> _chatHistory = [];
  List<String> get chatHistory => _chatHistory;
  final bool _isHistoryLoaded = false;
  Future<void> loadChatHistory() async {
    if (_userId == null || _isHistoryLoaded) return; //prevent loading
    _chatHistory.clear(); //clear it before new loading
    _chatHistory = await ChatDB.getUserChatHistory(_userId!);
    print("Loaded chat history in loadChatHistory: $_chatHistory");
    notifyListeners();
  }


  Future<List<String>> getChatHistory() async {
    if (_userId == null) return [];
    List<String> newHistory = await ChatDB.getUserChatHistory(_userId!);
    return newHistory;
  }


  LoadStatus get loadStatus => _loadStatus;
  List<String> get messages => _messages;
  String? get currentSessionId => _currentSessionId;

  void setUserId(int userId, String userEmail) {
    _userId = userId;
    _userEmail = userEmail;
    _chatHistory.clear();
    print("User ID set: $_userId");
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

  Future<void> startNewSession() async {
    if (_userId == null) return;

    // Kiểm tra nếu có session chưa có tin nhắn thì sử dụng session đó
    int? newSessionId = await ChatDB.createChatSession(_userId!);

    if (newSessionId != null) {
      _currentSessionId = newSessionId.toString();
      _messages.clear();
      await loadChatHistory();
      notifyListeners();
    }
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
      if (!scrollController.hasClients || !scrollController.position.hasContentDimensions) {
        return;
      }

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
