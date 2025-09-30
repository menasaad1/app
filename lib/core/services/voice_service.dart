import 'dart:async';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final TextToSpeech _textToSpeech = TextToSpeech();
  
  bool _isListening = false;
  bool _isSpeaking = false;
  final StreamController<String> _speechController = StreamController<String>.broadcast();
  final StreamController<VoiceStatus> _statusController = StreamController<VoiceStatus>.broadcast();

  // Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  Stream<String> get speechStream => _speechController.stream;
  Stream<VoiceStatus> get statusStream => _statusController.stream;

  // Initialize voice service
  Future<void> initialize() async {
    try {
      // Initialize speech to text
      await _speechToText.initialize();
      
      // Initialize text to speech
      await _textToSpeech.setLanguage('ar-SA');
      await _textToSpeech.setRate(0.5);
      await _textToSpeech.setPitch(1.0);
      await _textToSpeech.setVolume(1.0);
    } catch (e) {
      // Handle error silently
    }
  }

  // Start listening for speech
  Future<void> startListening() async {
    try {
      if (_isListening) return;
      
      final available = await _speechToText.initialize();
      if (!available) {
        throw Exception('خدمة التعرف على الكلام غير متاحة');
      }
      
      _isListening = true;
      _statusController.add(VoiceStatus.listening);
      
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _speechController.add(result.recognizedWords);
            _isListening = false;
            _statusController.add(VoiceStatus.stopped);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'ar_SA',
        onSoundLevelChange: (level) {
          _statusController.add(VoiceStatus.listening);
        },
      );
    } catch (e) {
      _isListening = false;
      _statusController.add(VoiceStatus.error(e.toString()));
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    try {
      if (!_isListening) return;
      
      await _speechToText.stop();
      _isListening = false;
      _statusController.add(VoiceStatus.stopped);
    } catch (e) {
      _isListening = false;
      _statusController.add(VoiceStatus.error(e.toString()));
    }
  }

  // Cancel listening
  Future<void> cancelListening() async {
    try {
      if (!_isListening) return;
      
      await _speechToText.cancel();
      _isListening = false;
      _statusController.add(VoiceStatus.cancelled);
    } catch (e) {
      _isListening = false;
      _statusController.add(VoiceStatus.error(e.toString()));
    }
  }

  // Speak text
  Future<void> speak(String text) async {
    try {
      if (_isSpeaking) return;
      
      _isSpeaking = true;
      _statusController.add(VoiceStatus.speaking);
      
      await _textToSpeech.speak(text);
      
      // Wait for speech to complete
      await Future.delayed(const Duration(seconds: 1));
      while (_textToSpeech.isSpeaking) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      _isSpeaking = false;
      _statusController.add(VoiceStatus.stopped);
    } catch (e) {
      _isSpeaking = false;
      _statusController.add(VoiceStatus.error(e.toString()));
    }
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    try {
      if (!_isSpeaking) return;
      
      await _textToSpeech.stop();
      _isSpeaking = false;
      _statusController.add(VoiceStatus.stopped);
    } catch (e) {
      _isSpeaking = false;
      _statusController.add(VoiceStatus.error(e.toString()));
    }
  }

  // Check if speech recognition is available
  Future<bool> isSpeechRecognitionAvailable() async {
    try {
      return await _speechToText.initialize();
    } catch (e) {
      return false;
    }
  }

  // Check if text to speech is available
  Future<bool> isTextToSpeechAvailable() async {
    try {
      return await _textToSpeech.getAvailableLanguages().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get available languages for speech recognition
  Future<List<String>> getAvailableLanguages() async {
    try {
      final locales = await _speechToText.locales();
      return locales.map((locale) => locale.localeId).toList();
    } catch (e) {
      return ['ar_SA', 'en_US'];
    }
  }

  // Get available languages for text to speech
  Future<List<String>> getAvailableTTSLanguages() async {
    try {
      return await _textToSpeech.getAvailableLanguages();
    } catch (e) {
      return ['ar-SA', 'en-US'];
    }
  }

  // Set language for speech recognition
  Future<void> setSpeechLanguage(String language) async {
    try {
      // This would be used when starting to listen
      // The language is set in the listen() method
    } catch (e) {
      // Handle error silently
    }
  }

  // Set language for text to speech
  Future<void> setTTSLanguage(String language) async {
    try {
      await _textToSpeech.setLanguage(language);
    } catch (e) {
      // Handle error silently
    }
  }

  // Set speech rate
  Future<void> setSpeechRate(double rate) async {
    try {
      await _textToSpeech.setRate(rate);
    } catch (e) {
      // Handle error silently
    }
  }

  // Set speech pitch
  Future<void> setSpeechPitch(double pitch) async {
    try {
      await _textToSpeech.setPitch(pitch);
    } catch (e) {
      // Handle error silently
    }
  }

  // Set speech volume
  Future<void> setSpeechVolume(double volume) async {
    try {
      await _textToSpeech.setVolume(volume);
    } catch (e) {
      // Handle error silently
    }
  }

  // Process voice command
  Future<String> processVoiceCommand(String command) async {
    try {
      final lowerCommand = command.toLowerCase();
      
      // Search commands
      if (lowerCommand.contains('ابحث عن') || lowerCommand.contains('search')) {
        final searchTerm = _extractSearchTerm(command);
        return 'search:$searchTerm';
      }
      
      // Navigation commands
      if (lowerCommand.contains('اذهب إلى') || lowerCommand.contains('go to')) {
        if (lowerCommand.contains('الأساقفة') || lowerCommand.contains('bishops')) {
          return 'navigate:bishops';
        } else if (lowerCommand.contains('التقارير') || lowerCommand.contains('reports')) {
          return 'navigate:reports';
        } else if (lowerCommand.contains('الإعدادات') || lowerCommand.contains('settings')) {
          return 'navigate:settings';
        }
      }
      
      // Action commands
      if (lowerCommand.contains('أضف') || lowerCommand.contains('add')) {
        return 'action:add_bishop';
      } else if (lowerCommand.contains('حذف') || lowerCommand.contains('delete')) {
        return 'action:delete_bishop';
      } else if (lowerCommand.contains('تعديل') || lowerCommand.contains('edit')) {
        return 'action:edit_bishop';
      }
      
      // Help commands
      if (lowerCommand.contains('مساعدة') || lowerCommand.contains('help')) {
        return 'action:help';
      }
      
      return 'unknown:$command';
    } catch (e) {
      return 'error:$e';
    }
  }

  // Extract search term from command
  String _extractSearchTerm(String command) {
    final patterns = [
      RegExp(r'ابحث عن (.+)'),
      RegExp(r'search (.+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(command);
      if (match != null) {
        return match.group(1)?.trim() ?? '';
      }
    }
    
    return '';
  }

  // Speak bishop information
  Future<void> speakBishopInfo(Map<String, dynamic> bishop) async {
    try {
      final name = bishop['name'] as String? ?? 'غير محدد';
      final title = bishop['title'] as String? ?? 'غير محدد';
      final diocese = bishop['diocese'] as String? ?? 'غير محدد';
      
      final text = 'الاسم: $name، اللقب: $title، الأبرشية: $diocese';
      await speak(text);
    } catch (e) {
      await speak('عذراً، لا يمكن قراءة معلومات الأسقف');
    }
  }

  // Speak search results
  Future<void> speakSearchResults(List<Map<String, dynamic>> results) async {
    try {
      if (results.isEmpty) {
        await speak('لم يتم العثور على نتائج');
        return;
      }
      
      final count = results.length;
      await speak('تم العثور على $count نتيجة');
      
      for (int i = 0; i < results.length && i < 3; i++) {
        final bishop = results[i];
        final name = bishop['name'] as String? ?? 'غير محدد';
        await speak('النتيجة ${i + 1}: $name');
      }
    } catch (e) {
      await speak('عذراً، لا يمكن قراءة نتائج البحث');
    }
  }

  // Speak error message
  Future<void> speakError(String error) async {
    try {
      await speak('عذراً، حدث خطأ: $error');
    } catch (e) {
      // Handle error silently
    }
  }

  // Speak success message
  Future<void> speakSuccess(String message) async {
    try {
      await speak('تم بنجاح: $message');
    } catch (e) {
      // Handle error silently
    }
  }

  // Get voice status
  VoiceStatus getCurrentStatus() {
    if (_isListening) return VoiceStatus.listening;
    if (_isSpeaking) return VoiceStatus.speaking;
    return VoiceStatus.idle;
  }

  // Dispose
  void dispose() {
    _speechController.close();
    _statusController.close();
  }
}

class VoiceStatus {
  final VoiceStatusType type;
  final String? message;

  VoiceStatus._(this.type, {this.message});

  factory VoiceStatus.idle() => VoiceStatus._(VoiceStatusType.idle);
  factory VoiceStatus.listening() => VoiceStatus._(VoiceStatusType.listening);
  factory VoiceStatus.speaking() => VoiceStatus._(VoiceStatusType.speaking);
  factory VoiceStatus.stopped() => VoiceStatus._(VoiceStatusType.stopped);
  factory VoiceStatus.cancelled() => VoiceStatus._(VoiceStatusType.cancelled);
  factory VoiceStatus.error(String message) => VoiceStatus._(VoiceStatusType.error, message: message);
}

enum VoiceStatusType {
  idle,
  listening,
  speaking,
  stopped,
  cancelled,
  error,
}
