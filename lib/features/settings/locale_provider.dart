import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Default to English
    return const Locale('en');
  }

  void setLocale(String languageCode) {
    state = Locale(languageCode);
  }
}
