import 'dart:convert';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/domain/repositories/dream_analysis_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'dream_analysis_repository_impl.g.dart';

// Retrieve API Key from .env
final _apiKey = dotenv.get('GEMINI_API_KEY', fallback: '');

@Riverpod(keepAlive: true)
DreamAnalysisRepository dreamAnalysisRepository(Ref ref) {
  return DreamAnalysisRepositoryImpl();
}

class DreamAnalysisRepositoryImpl implements DreamAnalysisRepository {
  late final GenerativeModel _model;
  final Box _box = Hive.box('dreams');

  DreamAnalysisRepositoryImpl() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
  }

  @override
  Future<DreamResponse> analyzeDream(String text) async {
    final prompt = [
      Content.text('''
You are a mystical and psychological dream analyst.

CRITICAL INSTRUCTIONS:
1. Analyze the user's dream text below.
2. AUTOMATICALLY DETECT the language of the input.
3. Provide your ENTIRE analysis in the SAME language as the input.
4. The detected_language field should be a two-letter ISO language code (e.g., "en", "tr", "es", "fr").
5. The archetypal_theme field MUST ALWAYS be in English (for image generation).

Return a JSON object with exactly these keys:
- interpretation: A 2-3 sentence mystical and poetic interpretation of the dream (in detected language).
- psychological_insight: A 1-2 sentence psychological perspective from a Jungian or modern viewpoint (in detected language).
- dream_guidance: A single powerful, actionable sentence to guide the user in their waking life based on the dream (in detected language).
- archetypal_theme: A descriptive English title and visual prompt (merged) for DALL-E to generate a surreal, cinematic, and mystical image of the dream. (This key MUST always be in English).
- detected_language: Two-letter ISO language code of the input text (e.g., "en", "tr", "es").

JSON format:
{
  "interpretation": "...",
  "psychological_insight": "...",
  "dream_guidance": "...",
  "archetypal_theme": "...",
  "detected_language": "..."
}
'''),
      Content.text(text),
    ];

    try {
      final response = await _model.generateContent(prompt);
      
      String? responseText = response.text;
      if (responseText == null) {
        throw Exception('Failed to generate analysis: Empty response.');
      }

      // Clean markdown code blocks if present
      if (responseText.contains('```')) {
        responseText = responseText.replaceAll(RegExp(r'```json|```'), '').trim();
      }

      final jsonMap = jsonDecode(responseText) as Map<String, dynamic>;
      
      // Persist to Hive
      try {
        await _box.add({
          'text': text,
          'date': DateTime.now().toIso8601String(),
          'analysis': jsonMap,
        });
      } catch (e) {
        debugPrint('⚠️ Failed to save dream to local storage: $e');
      }

      return DreamResponse.fromJson(jsonMap);
    } catch (e) {
      debugPrint('❌ Analysis Parsing Error: $e');
      throw Exception('Dream analysis failed: $e');
    }
  }
}
