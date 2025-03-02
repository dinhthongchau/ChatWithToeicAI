import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatProvider with ChangeNotifier {
  List<String> _messages = [];
  final ChatModel _chatModel;
  LoadStatus _loadStatus = LoadStatus.Init;
  final List<String> _chatHistory = Hive.box('chatHistory').get('history', defaultValue: <String>[]) ?? [];
  String? _currentSessionId; //store id current chat session
  ChatProvider(this._chatModel) {
    if (_chatModel == null) {
      throw ArgumentError('ChatModel cannot be null');
    }

  }

  //Getters
  List<String> get messages => _messages;

  LoadStatus get loadStatus => _loadStatus;

  get chatHistory => _chatHistory;

  String? get currentSessionId => _currentSessionId;

  void saveCurrentSession(String sessionId) {
    Hive.box('chatHistory').put(sessionId, _messages);
    if (!_chatHistory.contains(sessionId)) {
      _chatHistory.add(sessionId);
      Hive.box('chatHistory').put('history', _chatHistory); // update lít hítory
    }
    notifyListeners();
  }

  //
  void loadSession(String sessionId) {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(
          _currentSessionId!); // Lưu phiên hiện tại trước khi chuyển
    }
    _currentSessionId = sessionId;
    _messages = Hive.box('chatHistory')
            .get(sessionId, defaultValue: <String>[])?.cast<String>() ??
        [];
    _loadStatus = LoadStatus.Done;
    notifyListeners();
  }

  void startNewSession() {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(
          _currentSessionId!); // Lưu phiên hiện tại trước khi tạo mới
    }
    _messages = []; // Reset danh sách tin nhắn
    _currentSessionId =
        'Chat ${DateTime.now().toString().substring(0, 19)}'; // Tạo ID mới
    notifyListeners();
  }

  Future<void> addMessage(String message) async {
    if (_currentSessionId == null) {
      startNewSession(); // Tạo phiên mới nếu chưa có
    }
    _messages.add(message);
    _loadStatus = LoadStatus.Loading;
    notifyListeners();
    try {
      final response = await _chatModel.generateResponse(message);
      print(response);
      if (response != null) {
        _messages.add(response);
        _loadStatus = LoadStatus.Done;
        notifyListeners();

      }
    } catch (error) {
      _loadStatus = LoadStatus.Error;
    } finally {
      notifyListeners();
    }
  }

  void deleteChatSession(String sessionId) {
    Hive.box('chatHistory').delete(sessionId);
    _chatHistory.remove(sessionId);
    Hive.box('chatHistory').put('history', _chatHistory);
    notifyListeners();
  }



  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    notifyListeners(); // Cập nhật giao diện (nếu cần thêm thông báo trong UI)
  }


// Thêm vào class ChatProvider
  void renameChatSession(String oldSessionId, String newSessionId) {
    // Kiểm tra nếu tên mới đã tồn tại trong lịch sử
    if (_chatHistory.contains(newSessionId)) {
      return; // Không đổi tên nếu trùng để tránh xung đột
    }

    // Lấy dữ liệu của phiên cũ
    final sessionMessages = Hive.box('chatHistory').get(oldSessionId);

    // Xóa phiên cũ khỏi Hive và danh sách lịch sử
    Hive.box('chatHistory').delete(oldSessionId);
    _chatHistory.remove(oldSessionId);

    // Thêm phiên mới với tên mới và dữ liệu cũ
    Hive.box('chatHistory').put(newSessionId, sessionMessages);
    _chatHistory.add(newSessionId);
    Hive.box('chatHistory').put('history', _chatHistory);

    // Nếu phiên hiện tại đang được chọn, cập nhật currentSessionId
    if (_currentSessionId == oldSessionId) {
      _currentSessionId = newSessionId;
    }

    notifyListeners(); // Thông báo để giao diện cập nhật
  }


  void scrollToBottom(ScrollController scrollController ) {

    if (scrollController.hasClients) {

      WidgetsBinding.instance.addPostFrameCallback((_){
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

    }

  }

  void initScroll(ScrollController scrollController){
    WidgetsBinding.instance.addPostFrameCallback((_){
      scrollToBottom(scrollController);
    });
  }




}
