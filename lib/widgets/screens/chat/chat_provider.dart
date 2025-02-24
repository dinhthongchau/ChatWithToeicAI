import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier{

  List<String> _messages = [];
  final ChatModel _chatModel;
  LoadStatus _loadStatus =LoadStatus.Init;

  ChatProvider(this._chatModel){
    if(_chatModel == null){
      throw ArgumentError('ChatModel cannot be null');
    }
  }
  //Getters
  List<String> get messages => _messages;
  LoadStatus get loadStatus => _loadStatus;

  Future<void> addMessage(String message) async {
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
}