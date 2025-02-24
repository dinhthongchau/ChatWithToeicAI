import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier{

  List<String> _messages = [];
  final ChatModel _chatModel;

  ChatProvider(this._chatModel){
    if(_chatModel == null){
      throw ArgumentError('ChatModel cannot be null');
    }
  }

  List<String> get messages => _messages;

  Future<void> addMessage(String message) async {
    _messages.add(message);
    notifyListeners();

    final response = await _chatModel.generateResponse(message);
    print(response);
    if(response !=null){
      _messages.add(response);
      notifyListeners();
    }
  }
}