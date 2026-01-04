import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/features/profile/presentation/profile_screen.dart';
import 'package:dream_reader/features/nebula/presentation/nebula_screen.dart';
import 'package:dream_reader/features/insights/presentation/wisdom_hub_screen.dart';
import 'package:dream_reader/features/dream/presentation/dream_screen.dart';
import 'package:dream_reader/presentation/navigation/navigation_provider.dart';

import 'package:dream_reader/features/common/app_config_provider.dart';
import 'package:dream_reader/core/services/language_service.dart';

class MainEntryScreen extends ConsumerWidget {
  const MainEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final config = ref.watch(appConfigProvider);
    final locale = config.locale;

    return Scaffold(
      backgroundColor: Colors.black, // Root background
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          DreamScreen(), // 0
          NebulaScreen(), // 1
          WisdomHubScreen(), // 2
          ProfileScreen(), // 3
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? Container(
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  border: Border(
                      top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1))),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: -5)
                  ]),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                selectedItemColor: const Color(0xFF00F0FF),
                unselectedItemColor: Colors.white38,
                selectedLabelStyle:
                    GoogleFonts.orbitron(fontSize: 10, letterSpacing: 1),
                unselectedLabelStyle:
                    GoogleFonts.rajdhani(fontSize: 10, letterSpacing: 1),
                onTap: (index) {
                  ref.read(navigationIndexProvider.notifier).setIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.nightlight_round),
                    activeIcon: const Icon(Icons.nightlight_round, shadows: [
                      BoxShadow(color: Color(0xFF00F0FF), blurRadius: 10)
                    ]),
                    label: LanguageService.getString(locale, 'nav_record'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.auto_awesome_mosaic),
                    activeIcon: const Icon(Icons.auto_awesome_mosaic, shadows: [
                      BoxShadow(color: Color(0xFF00F0FF), blurRadius: 10)
                    ]),
                    label: LanguageService.getString(locale, 'nav_nebula'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.insights),
                    activeIcon: const Icon(Icons.insights, shadows: [
                      BoxShadow(color: Color(0xFF00F0FF), blurRadius: 10)
                    ]),
                    label: LanguageService.getString(locale, 'nav_wisdom'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    activeIcon: const Icon(Icons.person, shadows: [
                      BoxShadow(color: Color(0xFF00F0FF), blurRadius: 10)
                    ]),
                    label: LanguageService.getString(locale, 'nav_soul'),
                  ),
                ],
              ),
            )
          : null, // No bottom bar for desktop, assumes another nav mechanism or simple fallback
    );
  }
}
