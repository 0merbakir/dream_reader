import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService();
}

class AnalyticsService {
  final Box _box = Hive.box('dreams');

  List<Map<String, dynamic>> _getDreams() {
    return _box.values.map((e) {
      if (e is Map) {
        return Map<String, dynamic>.from(e);
      }
      return <String, dynamic>{};
    }).toList();
  }

  /// Dominant Emotion Logic (Mocked slightly as we don't extract explicit emotion tags yet)
  /// We will infer from 'archetypal_theme' keywords for now.
  Map<String, double> getDominantEmotions() {
    final dreams = _getDreams();
    // Use last 7
    final recent = dreams.length > 7 ? dreams.sublist(dreams.length - 7) : dreams;
    
    final Map<String, double> emotions = {
      'Fear': 0, 'Joy': 0, 'Wonder': 0, 'Anxiety': 0, 'Peace': 0
    };

    for (var dream in recent) {
      // Basic heuristic: check keywords in analysis text
      final analysis = dream['analysis'] ?? {};
      final text = (analysis['interpretation'] ?? '').toString() + (analysis['archetypal_theme'] ?? '').toString();
      final lower = text.toLowerCase();

      if (lower.contains('fear') || lower.contains('dark') || lower.contains('chase')) emotions['Fear'] = (emotions['Fear'] ?? 0) + 1;
      if (lower.contains('happy') || lower.contains('light') || lower.contains('flying')) emotions['Joy'] = (emotions['Joy'] ?? 0) + 1;
      if (lower.contains('mystical') || lower.contains('star') || lower.contains('cosmos')) emotions['Wonder'] = (emotions['Wonder'] ?? 0) + 1;
      if (lower.contains('worry') || lower.contains('lost') || lower.contains('late')) emotions['Anxiety'] = (emotions['Anxiety'] ?? 0) + 1;
      if (lower.contains('calm') || lower.contains('ocean') || lower.contains('garden')) emotions['Peace'] = (emotions['Peace'] ?? 0) + 1;
    }

    return emotions;
  }

  /// Symbol Frequency
  Map<String, int> getSymbolFrequency() {
    // Return mock data if empty, real if populated
    if (_box.isEmpty) {
        return {'Flight': 5, 'Water': 3, 'Teeth': 2, 'Falling': 4};
    }
    
    // Simple word frequency from "archetypal_theme"
    final freq = <String, int>{};
    for (var dream in _getDreams()) {
       final analysis = dream['analysis'] ?? {};
       final theme = (analysis['archetypal_theme'] ?? '').toString();
       final words = theme.split(' ');
       for (var word in words) {
         if (word.length > 4) {
           final w = word.replaceAll(RegExp(r'[^\w\s]+'), '').capitalize();
           freq[w] = (freq[w] ?? 0) + 1;
         }
       }
    }
    // Sort and take top 5
    final sortedKeys = freq.keys.toList()..sort((a, b) => freq[b]!.compareTo(freq[a]!));
    final top5 = <String, int>{};
    for (var i = 0; i < sortedKeys.length && i < 5; i++) {
      top5[sortedKeys[i]] = freq[sortedKeys[i]]!;
    }
    return top5.isEmpty ? {'Shadow': 1} : top5;
  }

  /// Dream Intensity (1-10)
  int getDreamIntensity() {
     if (_box.isEmpty) return 7; // Default
     
     final dreams = _getDreams();
     final lastDream = dreams.last;
     final text = lastDream['text'] as String? ?? "";
     
     // Simple metric: length / 20, clamped to 10
     return (text.length / 20).clamp(1, 10).toInt();
  }
}

extension StringExtension on String {
    String capitalize() {
      if (this.isEmpty) return "";
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}
