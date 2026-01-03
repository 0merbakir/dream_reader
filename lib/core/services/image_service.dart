import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dream_reader/features/subscription/user_subscription_provider.dart';

part 'image_service.g.dart';

@Riverpod(keepAlive: true)
ImageService imageService(Ref ref) {
  return ImageService(ref);
}

class ImageService {
  static const _url = 'https://api.openai.com/v1/images/generations';
  final String _apiKey = dotenv.get('OPENAI_API_KEY', fallback: '');
  final Ref _ref;

  ImageService(this._ref);

  Future<(String? url, String? error)> generateDreamImage(String visualPrompt) async {
    final isPremium = _ref.read(userSubscriptionProvider);

    // Free Tier: Logic
    if (!isPremium) {
       debugPrint('ℹ️ ImageService: User is Free Tier. Using Pollinations (Fast).');
       return _generatePollinationsImage(visualPrompt);
    }

    // Premium Tier: Logic
    debugPrint('💎 ImageService: User is PREMIUM. Attempting DALL-E 3 (High Def).');

    // If API Key is missing, go straight to fallback
    if (_apiKey.isEmpty) {
      debugPrint('ℹ️ ImageService: No OpenAI Key, falling back despite Premium.');
      return _generatePollinationsImage(visualPrompt);
    }

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': visualPrompt,
          'n': 1,
          'size': '1024x1024',
          'quality': 'hd', // HD for Premium
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'][0]['url'] as String, null);
      } else {
        final data = jsonDecode(response.body);
        final errorCode = data['error']?['code'];
        
        // If billing limit or quota reached, use fallback
        if (errorCode == 'billing_hard_limit_reached' || errorCode == 'insufficient_quota') {
          debugPrint('⚠️ DALL-E limit reached. Falling back to Pollinations.ai.');
          return _generatePollinationsImage(visualPrompt);
        }

        final errorMessage = (data['error']?['message'] ?? 'Unknown DALL-E Error') as String;
        return (null, errorMessage);
      }
    } catch (e) {
      debugPrint('❌ DALL-E Exception: $e. Falling back.');
      return _generatePollinationsImage(visualPrompt);
    }
  }

  Future<(String? url, String? error)> _generatePollinationsImage(String prompt) async {
    try {
      // Pollinations.ai is a direct URL generation service
      // No API key needed for basic usage. We use a random seed for uniqueness.
      final seed = DateTime.now().millisecondsSinceEpoch;
      final encodedPrompt = Uri.encodeComponent(prompt);
      
      // Requesting webp for efficiency
      final url = 'https://image.pollinations.ai/prompt/$encodedPrompt?seed=$seed&width=1024&height=1024&nologo=true&model=flux';
      
      return (url, null);
    } catch (e) {
      return (null, 'Pollinations Error: $e');
    }
  }
}
