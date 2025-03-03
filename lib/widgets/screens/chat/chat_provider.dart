import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatProvider with ChangeNotifier {
  final ChatModel _chatModel;
  ChatProvider(this._chatModel) ;
  //init
  List<String> _messages = [];
  List<String> _chatHistory=[];
  String? _currentSessionId;
  LoadStatus _loadStatus = LoadStatus.Init;

  //get
  LoadStatus get loadStatus => _loadStatus;
  List<String> get messages => _messages;
  String? get currentSessionId => _currentSessionId;
  List<String> get chatHistory => _chatHistory;
  //store chat current to Hive ( key,value is history: sessionId[], each sessionId: message[] )
  void saveCurrentSession(String sessionId){
    Hive.box('chatHistory').put(sessionId,_messages);
    if (!_chatHistory.contains(sessionId)){
      _chatHistory.add(sessionId);
      Hive.box('chatHistory').put('history',_chatHistory);
    }
    notifyListeners();
  }
  //load a chat in history
  void loadSession(String sessionId) {
    if(_messages.isNotEmpty && _currentSessionId != null){
      saveCurrentSession(_currentSessionId!);
    }
    _currentSessionId = sessionId;
    _messages = Hive.box('chatHistory').get(sessionId,defaultValue: <String>[]);
    notifyListeners();

  }
  //start new chat
  void startNewSession(){
    if(_messages.isNotEmpty && _currentSessionId != null ){
      saveCurrentSession(_currentSessionId!);
    }

    _messages =[];
    _currentSessionId = 'Chat ${DateTime.now()}';
    notifyListeners();
  }
  //add message with call api on current chat
  Future<void> addMessage(String message) async {
    if(_currentSessionId == null){
      startNewSession();
    }
    _messages.add(message);
    notifyListeners();
    _loadStatus = LoadStatus.Loading;
    try{
      final response = await _chatModel.generateResponse(message);
      if (response != null){
        _messages.add(response);
        notifyListeners();
        _loadStatus = LoadStatus.Done;
      }
    }
    catch(e){
      _loadStatus = LoadStatus.Error;
      print("Error call api $e");
    }
  }
  //copy selected message
  void copyMessage(String message){
    Clipboard.setData(ClipboardData(text: message));
    notifyListeners();
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

  void deleteChatSession(String sessionId) {
    Hive.box('chatHistory').delete(sessionId);
    _chatHistory.remove(sessionId);
    Hive.box('chatHistory').put('history', _chatHistory);
    notifyListeners();
  }

  void scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void initScroll(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(scrollController);
    });
  }
}
