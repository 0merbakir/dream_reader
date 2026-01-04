import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigState {
  final String locale; // 'en' or 'tr'
  final String voiceTone; // 'Gaia', 'Orion', 'Luna'
  final bool isPremium;

  const AppConfigState({
    this.locale = 'en',
    this.voiceTone = 'Gaia',
    this.isPremium = false,
  });

  AppConfigState copyWith({
    String? locale,
    String? voiceTone,
    bool? isPremium,
  }) {
    return AppConfigState(
      locale: locale ?? this.locale,
      voiceTone: voiceTone ?? this.voiceTone,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class AppConfigNotifier extends StateNotifier<AppConfigState> {
  AppConfigNotifier() : super(const AppConfigState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      locale: prefs.getString('locale') ?? 'en',
      voiceTone: prefs.getString('voiceTone') ?? 'Gaia',
      isPremium: prefs.getBool('isPremium') ?? false,
    );
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> setVoiceTone(String tone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voiceTone', tone);
    state = state.copyWith(voiceTone: tone);
  }

  Future<void> togglePremium() async {
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !state.isPremium;
    await prefs.setBool('isPremium', newStatus);
    state = state.copyWith(isPremium: newStatus);
  }
}

final appConfigProvider =
    StateNotifierProvider<AppConfigNotifier, AppConfigState>((ref) {
  return AppConfigNotifier();
});
