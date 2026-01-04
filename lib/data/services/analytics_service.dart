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
    final recent =
        dreams.length > 7 ? dreams.sublist(dreams.length - 7) : dreams;

    final Map<String, double> emotions = {
      'Fear': 0,
      'Joy': 0,
      'Wonder': 0,
      'Anxiety': 0,
      'Peace': 0
    };

    for (var dream in recent) {
      // Basic heuristic: check keywords in analysis text
      final analysis = dream['analysis'] ?? {};
      final text = (analysis['interpretation'] ?? '').toString() +
          (analysis['archetypal_theme'] ?? '').toString();
      final lower = text.toLowerCase();

      if (lower.contains('fear') ||
          lower.contains('dark') ||
          lower.contains('chase')) {
        emotions['Fear'] = (emotions['Fear'] ?? 0) + 1;
      }
      if (lower.contains('happy') ||
          lower.contains('light') ||
          lower.contains('flying')) {
        emotions['Joy'] = (emotions['Joy'] ?? 0) + 1;
      }
      if (lower.contains('mystical') ||
          lower.contains('star') ||
          lower.contains('cosmos')) {
        emotions['Wonder'] = (emotions['Wonder'] ?? 0) + 1;
      }
      if (lower.contains('worry') ||
          lower.contains('lost') ||
          lower.contains('late')) {
        emotions['Anxiety'] = (emotions['Anxiety'] ?? 0) + 1;
      }
      if (lower.contains('calm') ||
          lower.contains('ocean') ||
          lower.contains('garden')) {
        emotions['Peace'] = (emotions['Peace'] ?? 0) + 1;
      }
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
    final sortedKeys = freq.keys.toList()
      ..sort((a, b) => freq[b]!.compareTo(freq[a]!));
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

  int getTotalDreams() {
    return _box.length;
  }

  int getDreamerLevel() {
    // Level up every 5 dreams. Start at Level 1.
    return (_box.length / 5).floor() + 1;
  }

  String getClarityIndex() {
    if (_box.isEmpty) return "0%";

    // Calculate based on average length of dream text
    int totalLength = 0;
    final dreams = _getDreams();
    for (var dream in dreams) {
      totalLength += (dream['text'] as String? ?? "").length;
    }

    final avg = totalLength / dreams.length;
    // simple mapping: 50 chars = 10%, 500 chars = 100%
    final percentage = (avg / 500 * 100).clamp(0, 99).toInt();
    return "$percentage%";
  }

  String getSoulSymbol() {
    final symbols = getSymbolFrequency();
    if (symbols.isEmpty) return "Void";
    // Return key with highest value
    return symbols.keys.first;
  }

  Future<void> clearAllData() async {
    await _box.clear();
  }

  // --- MYSTICAL DATA FOR SACRED MAP ---

  Map<String, double> getArchetypeData() {
    // Labels: The Shadow, The Sage, The Traveler, The Guardian, The Eternal
    // In a real app, this would aggregate from dream tags.
    // Here we use a deterministic hash of the dream count to make it feel "live" but consistent.
    final seed = _box.length;
    return {
      "The Shadow": ((seed * 7) % 100) / 100.0,
      "The Sage": ((seed * 3) % 100) / 100.0,
      "The Traveler": ((seed * 5 + 20) % 100) / 100.0,
      "The Guardian": ((seed * 2 + 50) % 100) / 100.0,
      "The Eternal": ((seed * 11) % 100) / 100.0,
    };
  }

  // Returns list of spots for the last 7 days chart
  List<double> getVibrationData() {
    // Mocking a 7-day emotional frequency curve
    // Values between 0 (low vibe) and 5 (high vibe)
    if (_box.isEmpty) return [3, 2, 4, 3, 5, 4, 3];

    // Simple mock based on recent dreams length or sentiment if we had it
    // Let's return a fixed aesthetic curve for now
    return [2.5, 3.0, 4.2, 3.8, 4.5, 2.0, 3.5];
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
