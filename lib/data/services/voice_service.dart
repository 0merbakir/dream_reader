import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

part 'voice_service.g.dart';

@Riverpod(keepAlive: true)
VoiceService voiceService(Ref ref) {
  return VoiceService();
}

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Function(String)? _activeErrorCallback;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      await _speechToText
          .initialize(
        onError: (val) {
          debugPrint('Voice Error: ${val.errorMsg}');
          final message = _mapErrorToMessage(val.errorMsg);
          _activeErrorCallback?.call(message);
        },
        onStatus: (val) {
          debugPrint('Voice Status Global: $val');
        },
        debugLogging: true,
      )
          .then((initialized) {
        _isInitialized = initialized;
        debugPrint('Voice Service Initialized: $_isInitialized');
      }).catchError((e) {
        debugPrint('Voice Initialization Failed: $e');
        _isInitialized = false;
      });
    }

    // Attempt re-init if failed or check status
    if (!_isInitialized) {
      return false;
    }
    return _isInitialized;
  }

  String _mapErrorToMessage(String errorMsg) {
    if (errorMsg.contains('network')) {
      return 'Your cosmic link is weak. Check your internet.';
    } else if (errorMsg.contains('no_match')) {
      return 'The mists are too thick. Please speak more clearly.';
    } else if (errorMsg.contains('speech_timeout')) {
      return 'Silence is golden, but I need your voice to continue.';
    } else if (errorMsg.contains('denied') || errorMsg.contains('permission')) {
      return 'The stars need to hear you. Please enable microphone access in settings.';
    }
    return 'Voice Error: $errorMsg. Try again.';
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function(bool) onListeningStateChanged,
    required Function(String) onError,
    String localeId = 'en-US',
  }) async {
    _activeErrorCallback = onError;

    // 1. Permission Check
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        onError(
            'The stars need to hear you. Please enable microphone access in settings.');
        onListeningStateChanged(false);
        return;
      }
    }

    // 2. Initialization Check
    if (!_isInitialized) {
      final init = await initialize();
      if (!init) {
        onError('Voice service failed to initialize. Please restart the app.');
        return;
      }
    }

    onListeningStateChanged(true);

    _speechToText.statusListener = (status) {
      debugPrint('Voice Status Listener: $status');
      if (status == 'done' || status == 'notListening') {
        onListeningStateChanged(false);
      }
    };

    try {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        localeId: localeId,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 10),
        // ignore: deprecated_member_use
        listenMode: ListenMode.dictation,
        // ignore: deprecated_member_use
        cancelOnError: false,
        // ignore: deprecated_member_use
        partialResults: true,
      );
    } catch (e) {
      onError("Failed to start listening: $e");
      onListeningStateChanged(false);
    }
  }

  Future<void> stopListening() async {
    if (_isInitialized) {
      await _speechToText.stop();
    }
  }

  bool get isListening => _speechToText.isListening;
}
