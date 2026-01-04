import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/data/services/analytics_service.dart';
import 'package:dream_reader/features/common/app_config_provider.dart';
import 'package:dream_reader/core/services/language_service.dart';
import 'package:dream_reader/features/profile/presentation/widgets/aura_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(appConfigProvider);
    final locale = configState.locale;
    final isPremium = configState.isPremium;
    final analytics = ref.watch(analyticsServiceProvider);

    // Mystical Stats (Keep existing logic)
    final soulSymbol = analytics.getSoulSymbol();
    final auraColor = _getAuraColor(soulSymbol);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("THE DREAMER'S SOUL",
                style: GoogleFonts.orbitron(
                    letterSpacing: 4, color: Colors.white54, fontSize: 12)),

            const SizedBox(height: 40),
            AuraAvatar(
                imageUrl:
                    "https://ui-avatars.com/api/?name=Dream+Walker&background=0D0D0D&color=${auraColor.toHexString()}&size=200",
                auraColor: auraColor),

            const SizedBox(height: 24),
            Text("Dream Walker",
                style: GoogleFonts.orbitron(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: auraColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: auraColor.withValues(alpha: 0.5))),
              child: Text(isPremium ? "Awakened Mind" : "Wandering Soul",
                  style: GoogleFonts.rajdhani(
                      color: auraColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
            ),

            const SizedBox(height: 50),

            // SETTINGS GROUP 1: LANGUAGE
            _SectionHeader(
                title: LanguageService.getString(locale, 'settings_title')),
            const SizedBox(height: 20),
            _buildLanguageSelector(ref, locale),

            const SizedBox(height: 30),

            // SETTINGS GROUP 2: VOICE
            Align(
                alignment: Alignment.centerLeft,
                child: Text(LanguageService.getString(locale, 'voice_label'),
                    style: GoogleFonts.rajdhani(
                        color: Colors.white70, fontSize: 14))),
            const SizedBox(height: 12),
            _buildVoiceSelector(ref, configState.voiceTone),

            const SizedBox(height: 30),

            // SETTINGS GROUP 3: MASTERY (PREMIUM)
            Align(
                alignment: Alignment.centerLeft,
                child: Text(LanguageService.getString(locale, 'premium_label'),
                    style: GoogleFonts.rajdhani(
                        color: Colors.white70, fontSize: 14))),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LanguageService.getString(locale, 'test_premium'),
                  style: GoogleFonts.orbitron(color: Colors.white)),
              subtitle: Text(
                  LanguageService.getString(locale, 'premium_subtitle'),
                  style: GoogleFonts.rajdhani(color: Colors.white54)),
              value: isPremium,
              activeColor: const Color(0xFF00F0FF),
              onChanged: (val) =>
                  ref.read(appConfigProvider.notifier).togglePremium(),
            ),

            const SizedBox(height: 40),

            // Danger Zone (Create Space/Dissolve)
            Divider(color: Colors.white12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text("Dissolve Memory",
                  style: GoogleFonts.rajdhani(color: Colors.redAccent)),
              onTap: () async {
                await analytics.clearAllData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Memory Dissolved")));
                }
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(WidgetRef ref, String currentLocale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildLanguageOption(ref, "English", "en", currentLocale == "en"),
          _buildLanguageOption(ref, "Türkçe", "tr", currentLocale == "tr"),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      WidgetRef ref, String label, String code, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(appConfigProvider.notifier).setLocale(code),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7B61FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: GoogleFonts.orbitron(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildVoiceSelector(WidgetRef ref, String currentTone) {
    final tones = ["Gaia", "Orion", "Luna"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: tones.map((tone) {
        final isSelected = currentTone == tone;
        return GestureDetector(
          onTap: () => ref.read(appConfigProvider.notifier).setVoiceTone(tone),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? const Color(0xFF00F0FF) : Colors.white24),
              borderRadius: BorderRadius.circular(20),
              color: isSelected
                  ? const Color(0xFF00F0FF).withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
            child: Text(tone,
                style: GoogleFonts.rajdhani(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  Color _getAuraColor(String symbol) {
    if (symbol == "Void") return Colors.grey;
    final hash = symbol.codeUnits.fold(0, (p, c) => p + c);
    if (hash % 3 == 0) return const Color(0xFF00F0FF); // Cyan
    if (hash % 3 == 1) return const Color(0xFF7B61FF); // Purple
    return const Color(0xFFFF00E6); // Magenta
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          fontSize: 12,
          color: const Color(0xFF00F0FF).withValues(alpha: 0.5),
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  String toHexString() {
    // Returns RRGGBB hex string
    return '${(r * 255).round().toRadixString(16).padLeft(2, '0')}${(g * 255).round().toRadixString(16).padLeft(2, '0')}${(b * 255).round().toRadixString(16).padLeft(2, '0')}';
  }
}
