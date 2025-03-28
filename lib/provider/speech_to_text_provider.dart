import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  bool _hasSpeech = false;
  bool _isListening = false;
  String _currentLocaleId = '';

  SpeechToText get speech => _speech;
  bool get hasSpeech => _hasSpeech;
  bool get isListening => _isListening;
  String get currentLocaleId => _currentLocaleId;

  SpeechToTextProvider() {
    _initSpeechState();
  }

  // Khởi tạo SpeechToText
  Future<void> _initSpeechState() async {
    try {
      var hasSpeech = await _speech.initialize(
        onStatus: _statusListener,
        onError: _errorListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        // mã định danh ngôn ngữ hiện tại (Locale ID)
        var systemLocale = await _speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
        print('Speech initialized successfully, locale: $_currentLocaleId');
      } else {
        print('Speech initialization failed');
      }
      _hasSpeech = hasSpeech;
      notifyListeners();
    } catch (e) {
      print('Speech recognition failed: $e');
      _hasSpeech = false;
      notifyListeners();
    }
  }

  // Bắt đầu ghi âm với controller
  void startListening(TextEditingController controller) {
    if (!_hasSpeech || _isListening) return;
    controller.clear();
    _speech.listen(
      onResult: (result) => _resultListener(result, controller),
      localeId: _currentLocaleId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
    );
    _isListening = true;
    notifyListeners();
    print('Started listening');
  }

  // Dừng ghi âm
  void stopListening() {
    if (!_isListening) return;
    _speech.stop();
    _isListening = false;
    notifyListeners();
    print('Stopped listening');
  }

  // Xử lý kết quả nhận diện với controller từ ngoài
  void _resultListener(SpeechRecognitionResult result, TextEditingController controller) {
    controller.text = result.recognizedWords;
    notifyListeners();
    if (result.finalResult) {
      stopListening();
    }
    print('Recognized: ${result.recognizedWords}, Final: ${result.finalResult}');
  }


  void _statusListener(String status) {
    _isListening = _speech.isListening;
    notifyListeners();
    print('Status: $status');
  }


  void _errorListener(SpeechRecognitionError error) {
    _isListening = false;
    notifyListeners();
    print('Error: ${error.errorMsg}');
  }
}