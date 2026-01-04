import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dream_reader/core/services/language_service.dart';
import 'package:dream_reader/features/common/global_app_state.dart';

class WisdomHubScreen extends ConsumerWidget {
  const WisdomHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(globalAppStateProvider);
    final locale = appState.currentLocale.languageCode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 120,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(LanguageService.getString(locale, 'wisdom_title'),
                  style: GoogleFonts.orbitron(
                      color: Colors.white, fontSize: 14, letterSpacing: 2)),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _OracleGuideCard(
                  title: LanguageService.getString(locale, 'card_1_title'),
                  content: LanguageService.getString(locale, 'card_1_content'),
                  icon: Icons.brightness_high,
                  color: const Color(0xFF7B61FF),
                ),
                const SizedBox(height: 16),
                _OracleGuideCard(
                  title: LanguageService.getString(locale, 'card_2_title'),
                  content: LanguageService.getString(locale, 'card_2_content'),
                  icon: Icons.bedtime,
                  color: const Color(0xFF00F0FF),
                ),
                const SizedBox(height: 16),
                _OracleGuideCard(
                  title: LanguageService.getString(locale, 'card_3_title'),
                  content: LanguageService.getString(locale, 'card_3_content'),
                  icon: Icons.auto_awesome,
                  color: const Color(0xFFFF00A8),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _OracleGuideCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _OracleGuideCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(content,
              style: GoogleFonts.rajdhani(
                  color: Colors.white70, fontSize: 15, height: 1.5)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("LEARN MORE",
                  style: GoogleFonts.orbitron(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 10, color: color),
            ],
          ),
        ],
      ),
    );
  }
}
