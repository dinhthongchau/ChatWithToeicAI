import 'package:ct312hm01_temp/core/enum/load_tts_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechProvider with ChangeNotifier{
  final FlutterTts flutterTts = FlutterTts();
  LoadStatusTts _loadStatus = LoadStatusTts.isInit;
  LoadStatusTts get loadStatus => _loadStatus;

  Future<void> speak(String text) async {
    try{
      _loadStatus = LoadStatusTts.isPlaying;
      notifyListeners();
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.6);

      await flutterTts.speak(text);

    }
    catch(e){
      _loadStatus = LoadStatusTts.isError;
      notifyListeners();
      print("Error while speaking: $e");
    }


  }
  Future<void> stop() async {
    try{
      var result = await flutterTts.stop();
      if (result == 1) {
        _loadStatus =LoadStatusTts.isStop;
        notifyListeners();
      }
    }catch (e) {
      _loadStatus = LoadStatusTts.isError;
      notifyListeners();
      print("Error while stopping: $e");
    }
  }
}