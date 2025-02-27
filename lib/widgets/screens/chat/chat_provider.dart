import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatProvider with ChangeNotifier{

  List<String> _messages = [];
  final ChatModel _chatModel;
  LoadStatus _loadStatus =LoadStatus.Init;
  List<String> _chatHistory = Hive.box('chatHistory').get('history',defaultValue: <String>[]) ?? [];
  String? _currentSessionId; //store id current chat session
  ChatProvider(this._chatModel){
    if(_chatModel == null){
      throw ArgumentError('ChatModel cannot be null');
    }
  }
  //Getters
  List<String> get messages => _messages;
  LoadStatus get loadStatus => _loadStatus;
  get chatHistory => _chatHistory;
  String? get currentSessionId => _currentSessionId;
  void saveCurrentSession(String sessionId){
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
      saveCurrentSession(_currentSessionId!); // Lưu phiên hiện tại trước khi chuyển
    }
    _currentSessionId = sessionId;
    _messages = Hive.box('chatHistory').get(sessionId, defaultValue: <String>[])?.cast<String>() ?? [];
    _loadStatus = LoadStatus.Done;
    notifyListeners();
  }

  void startNewSession() {
    if (_messages.isNotEmpty && _currentSessionId != null) {
      saveCurrentSession(_currentSessionId!); // Lưu phiên hiện tại trước khi tạo mới
    }
    _messages = []; // Reset danh sách tin nhắn
    _currentSessionId = 'Chat ${DateTime.now().toString().substring(0, 19)}'; // Tạo ID mới
    notifyListeners();
  }

  Future<void> addMessage(String message) async {
    if (_currentSessionId == null) {
      startNewSession(); // Tạo phiên mới nếu chưa có
    }
    _messages.add(message);
    _loadStatus = LoadStatus.Loading;
    notifyListeners();
    try{
      final response = await _chatModel.generateResponse(message);
      print(response);
      if(response !=null){
        _messages.add(response);
        _loadStatus = LoadStatus.Done;
      }
    }
    catch(error){
      _loadStatus = LoadStatus.Error;
    }
    finally{
      notifyListeners();
    }


  }


  void deleteChatSession(String sessionId){
    Hive.box('chatHistory').delete(sessionId);
    _chatHistory.remove(sessionId);
    Hive.box('chatHistory').put('history', _chatHistory);
    notifyListeners();
  }
}