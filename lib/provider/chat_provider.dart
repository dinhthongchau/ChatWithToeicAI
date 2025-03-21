// import 'package:ct312hm01_temp/core/enum/load_status.dart';
// import 'package:ct312hm01_temp/services/chat_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/services/chat_service.dart';
import 'package:ct312hm01_temp/data/database/chat_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatModel;
  ChatProvider(this._chatModel);

  //init
  List<String> _messages = [];
  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.init;
  int _userId = -1; // Giá trị mặc định là -1 (guest user)
  String? _userEmail;
  LoadStatus get loadStatus => _loadStatus;
  List<String> get messages => _messages;
  String? get currentSessionId => _currentSessionId;
  int get userId => _userId; 
  String? get userEmail => _userEmail;
  final bool _isCreatingSession = false;
  bool get isCreatingSession => _isCreatingSession;
  List<String> _chatHistory = [];
  List<String> get chatHistory => _chatHistory;


  Future<void> loadChatHistory() async {
    if (_userId == -1) return; // Guest user không có lịch sử
    _chatHistory.clear();
    _chatHistory = await ChatDB.getUserChatHistory(_userId);
    print("Loaded chat history: $_chatHistory");
    notifyListeners();
  }


  Future<List<String>> getChatHistory() async {
    if (_userId == -1) return []; // Guest user trả về danh sách rỗng
    return await ChatDB.getUserChatHistory(_userId);
  }


  void setUserId(int userId, String? userEmail) {
    _userId = userId;
    _userEmail = userEmail;
    _chatHistory.clear();
    _messages.clear(); // Làm sạch tin nhắn khi thay đổi user
    _currentSessionId = null; // Đặt lại session
    print("User ID set: $_userId");
    notifyListeners();
  }

  // Save chat history for each user
  Future<void> saveCurrentSession(String sessionId) async {
    if (_userId == -1) return; // Không lưu cho guest user
    try {
      await ChatDB.saveChatSession(_userId, sessionId, _messages);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Load chat history by sessionId
  Future<void> loadSession(String sessionId) async {
    if (_userId == -1) return;

    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = sessionId;
    _messages = await ChatDB.loadChatMessages(_userId!, sessionId);
    notifyListeners();
  }


  Future<void> startNewSession() async {
    if (_userId == -1) {
      // Guest user: chỉ xóa tin nhắn, không tạo session trong DB
      _messages.clear();
      _currentSessionId = null;
      notifyListeners();
      return;
    }
    String newSessionId = await ChatDB.createChatSession(_userId);
    if (_messages.isNotEmpty && _currentSessionId != null) {
      await saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = newSessionId;
    _messages.clear();
    _chatHistory = await ChatDB.getUserChatHistory(_userId); // Tải trực tiếp
    print("New session started: $newSessionId, history: $_chatHistory");
    notifyListeners();
  }


  // Send message and call API to get response
  Future<void> addMessage(String message) async {
    if (_currentSessionId == null && _userId != -1) {
      startNewSession(); // Chỉ tạo session nếu không phải guest
    } else if (_userId == -1) {
      _messages.add(message); // Guest user: thêm tin nhắn mà không lưu
      notifyListeners();
      _loadStatus = LoadStatus.loading;
      try {
        final response = await _chatModel.generateResponse(message);
        if (response != null) {
          _messages.add(response);
          notifyListeners();
        }
        _loadStatus = LoadStatus.done;
      } catch (e) {
        _loadStatus = LoadStatus.error;
      }
      return;
    }

    // Kiểm tra xem tin nhắn đã tồn tại chưa
    if (!_messages.contains(message)) {
      _messages.add(message);
      notifyListeners();
      _loadStatus = LoadStatus.loading;
      try {
        final response = await _chatModel.generateResponse(message);
        if (response != null) {
          _messages.add(response);
          await saveCurrentSession(_currentSessionId!);
          notifyListeners();
        }
        _loadStatus = LoadStatus.done;
      } catch (e) {
        _loadStatus = LoadStatus.error;
      }
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
    if (_userId == null) {
      print("Error: User ID is null. Cannot rename chat session.");
      return;
    }

    if (oldSessionId == newSessionId) {
      print("Warning: Old and new session IDs are the same. No rename needed.");
      return;
    }

    if (newSessionId.trim().isEmpty) {
      print("Error: New session ID cannot be empty.");
      return;
    }

    try {
      await ChatDB.renameChatSession(_userId!, oldSessionId, newSessionId);
      if (_currentSessionId == oldSessionId) {
        _currentSessionId = newSessionId;
      }
      await loadChatHistory();
      notifyListeners();

    }
    catch(e){
      print(e);
    }
  }

  // Delete session chat
  Future<void> deleteChatSession(String sessionId) async {
    if (_userId == null) return;
    await ChatDB.deleteChatSession(_userId!, sessionId);
    await loadChatHistory(); // Tải lại lịch sử chat để cập nhật danh sách
    if (_currentSessionId == sessionId) {
      _currentSessionId = null; // Xóa session hiện tại nếu nó bị xóa
      _messages.clear(); // Xóa tin nhắn nếu đang ở session đó
    }
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
    _messages.clear();
    _messages =await ChatDB.loadChatMessages(_userId!, _currentSessionId!);
    notifyListeners();
  }

  // Reset tin nhắn
  void resetChat() {
    _messages.clear();
    notifyListeners();
  }
}
