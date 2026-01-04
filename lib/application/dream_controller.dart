import 'package:flutter/foundation.dart';
import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:dream_reader/core/services/image_service.dart';
import 'package:dream_reader/data/services/share_service.dart';
import 'package:dream_reader/data/services/voice_service.dart';
import 'package:dream_reader/data/services/analytics_service.dart';
import 'package:dream_reader/features/subscription/user_subscription_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_controller.g.dart';

@Riverpod(keepAlive: true)
class DreamController extends _$DreamController {
  late final FlutterTts _flutterTts;

  @override
  DreamState build() {
    _flutterTts = FlutterTts();
    _initTts();
    return const DreamState();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setPitch(0.9);
    await _flutterTts.setSpeechRate(0.4); // Deep, mystical voice
  }

  void startVoiceInput(String localeId) async {
    state = state.copyWith(isListening: true, error: null, transcription: '');

    final voiceService = ref.read(voiceServiceProvider);

    await voiceService.startListening(
      localeId: localeId,
      onResult: (text) {
        state = state.copyWith(transcription: text);
      },
      onError: (msg) {
        debugPrint('🎙️ Voice Error: $msg');
        state = state.copyWith(
          isListening: false,
          error: "Voice connection lost: $msg. Please try again.",
        );
      },
      onListeningStateChanged: (isListening) {
        state = state.copyWith(isListening: isListening);

        // Automatic Handshake Logic
        if (!isListening) {
          debugPrint('🎙️ Transcription Finished: ${state.transcription}');
          if (state.transcription.isNotEmpty) {
            analyzeDream(state.transcription);
          } else if (state.error == null) {
            // Only show "No speech detected" if there wasn't a harder error already
            state = state.copyWith(
              error: "I didn't catch that. Tap the mic and try again!",
            );
          }
        }
      },
    );
  }

  void stopVoiceInput() {
    ref.read(voiceServiceProvider).stopListening();
  }

  Future<void> analyzeDream(String dreamInput) async {
    // 1. Daily Limit Check (Monetization Pivot)
    final isPremium = ref.read(userSubscriptionProvider);
    if (!isPremium) {
      final repository = ref.read(dreamAnalysisRepositoryProvider);
      final dreams = repository.getDreams();
      final now = DateTime.now();
      final todayDreams = dreams.where((d) {
        // Assuming dream objects have a 'date' property, adjust as per actual Dream model
        final dDate = DateTime.tryParse(d.date); // Assuming d.date is a String
        return dDate != null &&
            dDate.year == now.year &&
            dDate.month == now.month &&
            dDate.day == now.day;
      }).length;

      if (todayDreams >= 1) {
        state = state.copyWith(isLoading: false, error: "DAILY_LIMIT_REACHED");
        return;
      }
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dreamAnalysisRepositoryProvider);
      final analysis =
          await repository.analyzeDream(dreamInput); // Use dreamInput here

      state = state.copyWith(
        isLoading: false,
        analysis: analysis,
      );

      // Start Image Generation in parallel
      _generateDreamImage(analysis.archetypalTheme);

      debugPrint(
          '🔊 TTS Started with detected language: ${analysis.detectedLanguage}');
      await speakResult(analysis.interpretation,
          languageCode: analysis.detectedLanguage);
    } catch (e) {
      debugPrint('❌ Submission Error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _generateDreamImage(String prompt) async {
    debugPrint('🎨 Generating DALL-E 3 Image: $prompt');
    state = state.copyWith(
      isImageLoading: true,
      imageError: null,
      imageUrl: null,
    );

    try {
      final service = ref.read(imageServiceProvider);
      final (url, error) = await service.generateDreamImage(prompt);

      if (url != null) {
        debugPrint('🖼️ Image Received');
        state = state.copyWith(imageUrl: url, isImageLoading: false);

        // --- PERSISTENCE: Save URL to the latest dream ---
        final analytics = ref.read(analyticsServiceProvider);
        final totalDreams = analytics.getTotalDreams();
        if (totalDreams > 0) {
          final repository = ref.read(dreamAnalysisRepositoryProvider);
          // The most recent dream is at index (length - 1)
          await repository.updateDreamImage(totalDreams - 1, url);
        }
        // -------------------------------------------------
      } else {
        debugPrint('❌ Image Error: $error');
        state = state.copyWith(imageError: error, isImageLoading: false);
      }
    } catch (e) {
      debugPrint('❌ Image Gen Exception: $e');
      state = state.copyWith(imageError: e.toString(), isImageLoading: false);
    }
  }

  Future<void> speakResult(String text, {String? languageCode}) async {
    if (languageCode != null) {
      // Find a matching locale for TTS
      // Most languages work with just the language code, but we can be specific
      await _flutterTts.setLanguage(languageCode);
    }
    await _flutterTts.speak(text);
  }

  Future<void> shareResult(Uint8List imageBytes) async {
    final analysis = state.analysis;
    if (analysis == null) return;

    state = state.copyWith(isSharingImage: true);

    try {
      final shareText =
          "🌌 Dream Interpretation:\n${analysis.interpretation}\n\n#DreamReader #CosmicInsights";

      await ref
          .read(shareServiceProvider)
          .shareDreamCard(imageBytes: imageBytes, text: shareText);

      state = state.copyWith(isSharingImage: false);
    } catch (e) {
      debugPrint('❌ Share failed: $e');
      state = state.copyWith(
        isSharingImage: false,
        error: "Failed to share dream card. Please try again.",
      );
    }
  }
}
