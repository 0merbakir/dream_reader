import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalAppState extends ChangeNotifier {
  // State Variables
  Locale _currentLocale = const Locale('en');
  String _activeTune = 'Gaia';
  bool _isPremium = false;
  String _currentVibeFilter = 'All';
  List<Map<String, dynamic>> _dreamList = [];

  // Getters
  Locale get currentLocale => _currentLocale;
  String get activeTune => _activeTune;
  bool get isPremium => _isPremium;
  String get currentVibeFilter => _currentVibeFilter;
  List<Map<String, dynamic>> get dreamList => _dreamList;

  // Singleton Support (Optional but good for global access if needed, though Provider is better)
  // For now, we rely on Provider.

  GlobalAppState() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale_code') ?? 'en';
    _currentLocale = Locale(langCode);
    _activeTune = prefs.getString('voice_tune') ?? 'Gaia';
    _isPremium = prefs.getBool('is_premium') ?? false;
    notifyListeners();
  }

  void setVibeFilter(String filter) {
    if (_currentVibeFilter == filter) return;
    _currentVibeFilter = filter;
    notifyListeners();
  }

  void syncDreams(List<dynamic> dreams) {
    // Convert generic dynamic list to Map list if possible or just store
    // Ensure deep equality check? For now just set.
    final casted =
        dreams.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    _dreamList = casted;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_code', locale.languageCode);
    notifyListeners();
  }

  Future<void> setVoiceTune(String tune) async {
    if (_activeTune == tune) return;
    _activeTune = tune;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voice_tune', tune);
    notifyListeners();
  }

  Future<void> togglePremium() async {
    _isPremium = !_isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', _isPremium);
    notifyListeners();
  }

  // Debug/Dev helper
  void setPremium(bool value) {
    if (_isPremium == value) return;
    _isPremium = value;
    notifyListeners();
  }
}

final globalAppStateProvider = ChangeNotifierProvider<GlobalAppState>((ref) {
  return GlobalAppState();
});
